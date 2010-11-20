module QOS
  module AdminController
    get '/admin' do
      redirect '/admin/index'
    end

    get '/admin/index' do
      redirect '/admin/verify_reload'
    end # get '/admin/index' do
    
    get '/admin/verify_reload' do
      erb :'admin/verify_reload'
    end # get '/admin/verify_reload' do
    
    get '/admin/do_reload' do
      # find the node
      Node.all.each do |node|
        # pass the node to the template
        @node = node

        # get all the cidrs
        @cidrs = Cidr.find(:all, :conditions => { :node_id => node.id })

        # set some system-wide variables
        @mark_in = $config['iptables']['mark_prefix_in'] + "%04d" % node.id
        @mark_out = $config['iptables']['mark_prefix_out'] + "%04d" % node.id

        system_iptables = erb :'system/iptables', :layout => false
	system(system_iptables)
      end # Node.all.each do |node|

      @nodes = Node.all
      @rate_max = $config['general']['rate_max']

      system_tc = erb :'system/tc', :layout => false
      system(system_tc)

      erb :'admin/do_reload'
    end # get '/admin/do_reload' do
  end # module AdminController
end # module QOS
