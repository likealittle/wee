require 'wee/page'
require 'wee/state_registry'
require 'wee/callback'
require 'thread'

class Wee::Session
  attr_accessor :root_component, :page_store
  attr_reader :state_registry

  def self.current
    sess = Thread.current['Wee::Session']
    raise "not in session" if sess.nil?
    return sess
  end

  def register_object_for_backtracking(obj)
    @state_registry << obj
  end

  def initialize(&block)
    Thread.current['Wee::Session'] = self

    @next_page_id = 0
    @mutex = Mutex.new
    @state_registry = Wee::StateRegistry.new

    block.call(self)

    raise ArgumentError, "No root component specified" if @root_component.nil?
    raise ArgumentError, "No page_store specified" if @page_store.nil?
    
    @initial_snapshot = @state_registry.snapshot 

  ensure
    Thread.current['Wee::Session'] = nil
  end

  def setup(context)
  end

  def handle_request(context)
    Thread.current['Wee::Session'] = self

    @mutex.synchronize do 

    setup(context)

    if context.page_id.nil?

      # No page_id was specified in the URL. This means that we start with a
      # fresh component and a fresh page_id, then redirect to render itself.

      handle_new_page_view(context, @initial_snapshot)

    elsif page = @page_store.fetch(context.page_id, false)

      # A valid page_id was specified and the corresponding page exists.

      page.snapshot.apply

      if context.handler_id.nil?

        # No action/inputs were specified -> render page
        #
        # 1. Reset the action/input fields (as they are regenerated in the
        #    rendering process).
        # 2. Render the page (respond).
        # 3. Store the page back into the store (only neccessary if page is not
        #    stored in memory).

        page = Wee::Page.new(page.snapshot, Wee::CallbackRegistry.new)  # remove all action/input handlers
        context.callback_registry = page.callback_registry
        respond(context.freeze)                     # render
        @page_store[context.page_id] = page         # store

      else

        # Actions/inputs were specified.
        #
        # We process the request and invoke actions/inputs. Then we generate a
        # new page view. 

        s = context.request.query.dup.update({context.handler_id => nil})
        callback_stream = page.callback_registry.create_callback_stream(s)

        @root_component.process_callback_chain(callback_stream)
        handle_new_page_view(context.freeze)
      end

    else

      # A page_id was specified in the URL, but there's no page for it in the
      # page store.  Either the page has timed out, or an invalid page_id was
      # specified. 
      #
      # TODO:: Display an "invalid page or page timed out" message, which
      # forwards to /app/session-id

      raise "Not yet implemented"

    end

    end # mutex

  ensure
    Thread.current['Wee::Session'] = nil
  end

  private

  def handle_new_page_view(context, snapshot=nil)
    new_page_id = create_new_page_id() 
    new_page = Wee::Page.new(snapshot || @state_registry.snapshot, Wee::CallbackRegistry.new)
    @page_store[new_page_id] = new_page

    redirect_url = "#{ context.application.path }/s:#{ context.session_id }/p:#{ new_page_id }"
    context.response.set_redirect(WEBrick::HTTPStatus::MovedPermanently, redirect_url)
  end

  def respond(context)
    context.response.status = 200
    context.response['Content-Type'] = 'text/html'

    rctx = Wee::RenderingContext.new(context, Wee::HtmlWriter.new(context.response.body))
    @root_component.render_chain(rctx)
  end

  def create_new_page_id
    @next_page_id.to_s
  ensure
    @next_page_id += 1
  end

end