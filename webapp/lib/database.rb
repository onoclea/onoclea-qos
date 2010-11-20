db_config = YAML.load(File.read(ROOT_DIR + '/../config/database.yaml'))['production']

ActiveRecord::Base.establish_connection(db_config)

class Node < ActiveRecord::Base
  has_many :cidrs
  has_one :limit

  def flow_id
    self.id + 10
  end

  def mark_in
    $config['iptables']['mark_prefix_in'] + "%04d" % self.id
  end

  def mark_out
    $config['iptables']['mark_prefix_out'] + "%04d" % self.id
  end
end

class Cidr < ActiveRecord::Base
  belongs_to :node
end

class Limit < ActiveRecord::Base
  belongs_to :node
end
