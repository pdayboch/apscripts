require 'net/ssh'

# replace this with a path to YOUR private key, probably needs to be not password protected FYI
MRKI_SSH_KEY = '~/.ssh/philip_private_key'

module Ssh

  def Ssh.do_ssh(ip, cmd)
    20.times do
      begin
        Net::SSH.start(ip, 'root') do |ssh|
          result = ''; data = ''
          ssh.exec!(cmd) do | channel, stream, data |
            if stream == :stderr
              puts "We had a booboo"
              raise "Error in fetching file data"
            end
            result << data
          end # end the SSH exec ch, st, data block
          return result
        end # end the NET SSH block
      rescue => e
        result = "do_ssh - couldn't run #{cmd} on #{ip}: #{e}"
        return result
      end # end begin rescue
      sleep 10
    end # end 20 times loop
  end # end method


  # Adds or replaces ECOs on this node
  # TODO: Support more than one ECO, currently only supports the one, because it returns after first result
  # @param ap_tunnel_ip [String] node IP
  # @param ecos [String] ECOs_to_add (currently returns after the first ECO, TODO: support multiple)
  # @return [String] results
  def add_or_replace_eco(ap_tunnel_ip, ecos = nil)
    if !ecos.empty?
      ecos.each_line do |eco|
        eco.strip!
        eco_base = /^[^\s]*/.match(eco)
        # grep checks if the config option exists
        # if it does 'sed' searches and replaces with the new config option
        # otherwise we add the config option to the config file
        cmd = "grep -q '^#{eco_base} .*' /storage/config.local && sed -i 's/^#{eco_base} .*/#{eco}/g' /storage/config.local || echo '#{eco}' >> /storage/config.local"
        result = do_ssh(ap_tunnel_ip, cmd)
        return result ? result : false
      end # end echo each block
    end # end if eco list empty
  end # end method
end
