require './lib/apscripts/ssh.rb'

class Setup
  attr_accessor :aps

  def initialize(rawIPs)
    @aps = Hash.new

    ips = parseIps(rawIPs)

    ips.each do |ip|
      @aps[ip.chomp] = Hash.new
    end

    getConfig
    parseConfig("product_model", :model)
    parseConfig("node_name", :name)
  end

  private
  def parseIps(rawIPs)
    ips = rawIPs.split("\n")
    return ips
  end

  private
  def getConfig()
    cmd = "cat /storage/config"
    @aps.each do |ip, info|
      config = Ssh.do_ssh(ip, cmd)
      @aps[ip][:config] = config
    end
  end

  private
  def parseConfig(lineText, hashId)
    @aps.each do |ip, info|
      foundline = info[:config].match(/^#{lineText}.*/)[0]
      des = foundline.match(/\s.*/)[0].strip
      info[hashId] = des
    end
  end

end
