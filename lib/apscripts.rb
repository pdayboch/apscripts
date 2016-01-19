require './lib/apscripts/ssh.rb'
require 'tilt/erb'

class Setup
  attr_accessor :aps

  def initialize(rawIPs)
    @aps = Hash.new
    ips = parseIps(rawIPs)

    getData
  end

  private
  def parseIps(rawIPs)
    ips = rawIPs.split("\n")
    ips.each do |ip|
      if !ip.match(/^fd0a:9b09:1f7/)
        m = ip.split(":")
        hex = m[0].to_i(16)
        flip = hex ^ 0x02
        flippedMac = "#{flip.to_s(16)}#{m[1]}:#{m[2]}ff:fe#{m[3]}:#{m[4]}#{m[5]}"
        ipv6 = "fd0a:9b09:1f7:0:#{flippedMac}"
        ip = ipv6
      end
      @aps[ip.chomp] = Hash.new
    end
    return ips
  end

  private
  def getData()
    threads = []
    @aps.each do |ip, info|
      sleep(0.1)
      threads.push(Thread.new{
        getConfig(ip)
        getBuild(ip)
        parseConfig(ip, "product_model", :model)
        parseConfig(ip, "node_name", :name)
      })
    end
    threads.each do |t|
      t.join
    end
  end

  private
  def getConfig(ip)
    cmd = "cat /storage/config"
    config = Ssh.do_ssh(ip, cmd)
    @aps[ip][:config] = config
  end

  def getBuild(ip)
    cmd = "cat /MERAKI_BUILD"
    config = Ssh.do_ssh(ip, cmd)
    @aps[ip][:build] = config
  end

  private
  def parseConfig(ip, lineText, hashId)
    info = @aps[ip]
    result = info[:config].match(/^#{lineText}.*/)
    if result
      foundline = result[0]
      des = foundline.match(/\s.*/)[0].strip
      info[hashId] = des
    else
      info[hashId] = "Not Found"
    end
  end

end
