require 'wee/page'
require 'thread'

class Wee::Session
  attr_accessor :root_component, :page_store

  def self.current
    sess = Thread.current['Wee::Session']
    raise "not in session" if sess.nil?
    return sess
  end

  def initialize(&block)
    Thread.current['Wee::Session'] = self

    @idgen = Wee::SimpleIdGenerator.new
    @in_queue, @out_queue = SizedQueue.new(1), SizedQueue.new(1)

    @continuation_stack = []

    block.call(self)

    raise ArgumentError, "No root component specified" if @root_component.nil?
    raise ArgumentError, "No page_store specified" if @page_store.nil?
    
    @initial_snapshot = snapshot()

    start_request_response_loop
  ensure
    Thread.current['Wee::Session'] = nil
  end

  def snapshot
    @root_component.backtrack_state_chain(snap = Wee::Snapshot.new)
    snap.add(@continuation_stack)
    return snap.freeze
  end


  # called by application to send the session a request
  def handle_request(context)

    # Send a request to the session. If the session is currently busy
    # processing another request, this will block. 
    @in_queue.push(context)

    # Wait for the response.
    context = @out_queue.pop

    # TODO: can't move into session?
    if context.redirect
      context.response.set_redirect(WEBrick::HTTPStatus::MovedPermanently, context.redirect)
    end
  end

  def start_request_response_loop
    Thread.abort_on_exception = true
    Thread.new {
      Thread.current['Wee::Session'] = self

      loop {
        @context = @in_queue.pop
        process_request
        @out_queue.push(@context)
      }
    }
  end

  attr_reader :continuation_stack

  def create_page(snapshot)
    idgen = Wee::SimpleIdGenerator.new
    page = Wee::Page.new(snapshot, Wee::CallbackRegistry.new(idgen))
  end

  def process_request
    if @context.page_id.nil?

      # No page_id was specified in the URL. This means that we start with a
      # fresh component and a fresh page_id, then redirect to render itself.

      handle_new_page_view(@context, @initial_snapshot)

    elsif page = @page_store.fetch(@context.page_id, false)

      # A valid page_id was specified and the corresponding page exists.

      page.snapshot.restore

      if @context.handler_id.nil?

        # No action/inputs were specified -> render page
        #
        # 1. Reset the action/input fields (as they are regenerated in the
        #    rendering process).
        # 2. Render the page (respond).
        # 3. Store the page back into the store

        page = create_page(page.snapshot)  # remove all action/input handlers
        @context.callbacks = page.callbacks
        respond(@context)                            # render
        @page_store[@context.page_id] = page         # store

      else

        # Actions/inputs were specified.
        #
        # We process the request and invoke actions/inputs. Then we generate a
        # new page view. 

        s = {@context.handler_id => nil}.update(@context.request.query)
        callback_stream = Wee::CallbackStream.new(page.callbacks, s) 

        catch(:wee_back_to_session) {
          @root_component.process_callback_chain(callback_stream)
        }
        handle_new_page_view(@context)

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
  end

  private

  def handle_new_page_view(context, snapshot=nil)
    new_page_id = @idgen.next.to_s
    new_page = create_page(snapshot || self.snapshot())
    @page_store[new_page_id] = new_page

    redirect_url = "#{ context.application.path }/s:#{ context.session_id }/p:#{ new_page_id }"
    context.redirect = redirect_url
  end

  def respond(context)
    context.response.status = 200
    context.response['Content-Type'] = 'text/html'

    rctx = Wee::RenderingContext.new(context, Wee::HtmlWriter.new(context.response.body))
    @root_component.render_chain(rctx)
  end

end
