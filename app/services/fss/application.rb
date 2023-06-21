# frozen_string_literal: true

# Генерация сообщений xml и отправка через soap в ФСС
# reload!; Fss::Application.new(actor: '1027739443236', ogrn: '1027500716143', operation: :get_new_ln_num).call.body
module Fss
  class Application
    require 'base64'
    require 'chilkat'

    include CryptoGost3411

    WSDL = 'https://eln-test.fss.ru/WSLnV20/FileOperationsLnService?WSDL'

    attr_reader :actor, :ogrn, :operation

    def initialize(actor: nil, ogrn: nil, operation: nil)
      @actor = actor
      @ogrn = ogrn
      @operation = operation
    end

    def call
      response
    end

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

    def examples
      # puts text = "<soapenv:Body wsu:Id=\"OGRN_1027500716143\">\n  <v01:getNewLNNumRequest>\n    <v01:ogrn>1027500716143</v01:ogrn>\n  </v01:getNewLNNumRequest>\n</soapenv:Body>"
      # puts Base64.encode64(OpenSSL::Digest::SHA1.digest('TEXT')).chop
      # puts text2 = 'h–YYð¬ïÙ[N¢Õ ^÷ys-¡Ùßt&ÅÎú6E'
      envelop = <<-TEXT
<soapenv:Body wsu:Id="OGRN_1027500716143">
  <v01:getNewLNNumRequest>
    <v01:ogrn>1027500716143</v01:ogrn>
  </v01:getNewLNNumRequest>
</soapenv:Body>
      TEXT
      puts text = Nokogiri::XML(envelop) { |config| config.strict }.canonicalize
      debugger
      puts Base64.encode64('f???p?J????4?4?>?S?`?HM=??~F$s').chop
      puts digest_value = 'VxP6uAm/bMwcjy2ZmiynC/H39+smHgnV7lkxiie7XOM='
      puts Base64.encode64('?c5CJk?$?ʬ^?j?yizġ)?N?"??KS ?').chop
      puts digest_value = 'VxP6uAm/bMwcjy2ZmiynC/H39+smHgnV7lkxiie7XOM='

      # puts digest64 = Gost3411.new(64).update(data1).final
      # puts base64_from_bytes = Base64.encode64(digest64)
      # puts base64_from_str = Base64.encode64(data1.each_byte.to_a.join)
      # puts digest64.unpack('H*')[0].scan(/.{16}/).each{|line| puts line}
    end

    private

    def response
      @response ||= client.call(operation, message: canonicalize_envelop)
    end

    def client
      @client ||= Savon.client(wsdl: self.class.const_get('WSDL'))
    end


    def envelop
      @envelop ||= Fss::Envelop.new(actor: actor, ogrn: ogrn, operation: operation).call
    end

    def canonicalize_envelop
      @canonicalize_envelop ||= Nokogiri::XML(envelop) { |config| config.strict }.canonicalize
    end

    # [:pr_parse_filelnlpu,
    #  :get_ln_list_by_date,
    #  :get_ln_list_by_snils,
    #  :get_existing_ln_num_range,
    #  :get_new_ln_num,
    #  :get_new_ln_num_range,
    #  :get_ln_data,
    #  :disable_ln]
    def operations
      @operations ||= client.operations
    end
  end
end

