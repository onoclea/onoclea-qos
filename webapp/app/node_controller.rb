require 'pp'

module QOS
  module NodeController
    get '/' do
      redirect '/nodes/index'
    end
    
    get '/nodes/index' do
      @nodes = Node.all()
    
      erb :'nodes/index'
    end
    
    get '/nodes/view/:name' do
      @node = Node.find(:first, :conditions => { :name => params[:name] })
    
      erb :'nodes/view'
    end

    get '/nodes/add' do
      erb :'nodes/add'
    end # get '/admin/add'

    post '/nodes/add' do
      @name = params[:name]
      @comment = params[:comment]

      if @name =~ /^\w+$/
        node = Node.create(:name => @name.downcase, :comment => @comment)

        # pass the node to the template
        @node = node

        @rrd_dir_path = $config['general']['prefix'] + '/rrd'

        system_rrd_create = erb :'system/rrd_create', :layout => false

        system(system_rrd_create)

        redirect '/nodes/index'
      else
        @message = 'Node name cannot be empty and must contain only letters, digits or the underscore sign.'
        erb :'nodes/add'
      end # if @name.empty?
    end # post '/nodes/add'

    get '/nodes/edit/:name' do
      @node = Node.find(:first, :conditions => { :name => params[:name] })

      @cidrs = Cidr.find(:all, :conditions => { :node_id => @node.id })

      if @node.limit.nil?

        @node.limit = Limit.new(:node_id => @node.id, :rate => '1mbit', :ceil => '1mbit')

        @node.save
      end

      erb :'nodes/edit'
    end # get '/nodes/edit/:name' do

    post '/nodes/edit/:name' do
      comment = params[:comment]
      cidrs = params[:cidrs]
      rate = params[:rate]
      ceil = params[:ceil]

      @node = Node.find(:first, :conditions => { :name => params[:name] })

      @node.comment = comment

      @node.limit.rate = rate
      @node.limit.ceil = ceil

      @node.limit.save

      @node.cidrs.destroy_all

      cidrs.split.each do |cidr|
        # XXX: FIXME: Get a better regexp.
        if cidr =~ /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?\/\d{1,2}$/
          @node.cidrs << Cidr.new(:node_id => @node.id, :cidr => cidr)
        end
      end

      @node.save

      p @node.limit

      redirect '/nodes/index'
    end # post '/nodes/edit/:name' do
  end # module NodeController
end # module QOS
