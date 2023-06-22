module Crypto
  class Examples
    require 'base64'
    require 'chilkat'

    include CryptoGost3411

    def digest_value_generate
      pp 'example 1:'
      example_1
      pp '='
      pp 'example 2:'
      example_2
      pp '='
      pp 'example 3:'
      example_3
      nil
    end

    def example_1
      envelop = <<-TEXT
<soapenv:Body xmlns="http://www.w3.org/2000/09/xmldsig#" wsu:Id="OGRN_1027500716143">
  <getNewLNNumRequest>
    <ogrn>1027500716143</ogrn>
  </getNewLNNumRequest>
</soapenv:Body>
      TEXT
      canon_and_crypt(envelop)
      nil
    end

    def example_2
      envelope = '<soapenv:Body xmlns="http://www.w3.org/2000/09/xmldsig#" wsu:Id="OGRN_1027500716143"><v01:getNewLNNumRequest><v01:ogrn>1027500716143</v01:ogrn></v01:getNewLNNumRequest></soapenv:Body>'
      canon_and_crypt(envelope)
      nil
    end

    def example_3
      envelop = <<-TEXT
<Object xmlns="http://www.w3.org/2000/09/xmldsig#" Id="object">some text
  with spaces and CR-LF.</Object>
      TEXT
      a = Digest::SHA1.hexdigest envelop
      pp [[a].pack('H*')].pack('m0')
      pp 'OPnpF/ZNLDxJ/I+1F3iHhlmSwgo='
      nil
    end

    def canon_and_crypt(envelop, filename = 'get_new_ln_num.xml')
      canonXml = Chilkat::CkXmlDSig.new().canonicalizeXml(envelop, 'EXCL_C14N', true)
      cryptcp_to_hex(canonXml, filename)

      canonXml = Nokogiri::XML(envelop) { |config| config.strict }.canonicalize
      cryptcp_to_hex(canonXml, filename)

      pp 'gem:'
      digest64 = Gost3411.new(32).update(canonXml).final.unpack('H*')[0]
      pp [[digest64].pack('H*')].pack('m0')
      nil
    end

    def cryptcp_to_hex(canonXml, filename = 'get_new_ln_num.xml')
      File.write("#{Rails.root}/public/xml/canon/#{filename}", canonXml)
      `cd #{Rails.root}/public/xml/canon/ && cryptcp -hash -provtype 75 -hashAlg 1.2.643.7.1.1.2.2 -hex #{filename}`
      hex_to_base64("#{filename}.hsh")
      nil
    end

    def hex_to_base64(filename)
      hexdigest ||= File.read("#{Rails.root}/public/xml/canon/#{filename}")
      pp [[hexdigest].pack('H*')].pack('m0')
      pp 'must:'
      pp 'VxP6uAm/bMwcjy2ZmiynC/H39+smHgnV7lkxiie7XOM='
      pp '-'
      nil
    end
  end
end
