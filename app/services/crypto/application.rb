# frozen_string_literal: true

# КриптоПро утилиты
module Crypto
  class Application
    INPUT_EXAMPLE = '<soapenv:Body xmlns="http://www.w3.org/2000/09/xmldsig#" wsu:Id="OGRN_1027500716143"><v01:getNewLNNumRequest><v01:ogrn>1027500716143</v01:ogrn></v01:getNewLNNumRequest></soapenv:Body>'

    attr_reader :operation, :input, :container, :cert, :dir
    attr_accessor :output

    def initialize(operation: nil, input: self.class.const_get('INPUT_EXAMPLE'), container: 'uMy', cert: 'CN=Oleg')
      @operation = operation
      @input = input
      @output = nil
      @container = container
      @cert = cert
      @dir = "#{Rails.root}/public/xml/canon"
    end

    def call
      File.write("#{dir}/data.input", input)
      send(operation)
      File.delete("#{dir}/data.input")
      output
    end

    private

    def create_hash(hex: true)
      `cd #{dir} && cryptcp -hash -provtype 75 -hashAlg 1.2.643.7.1.1.2.2 #{hex ? '-hex' : ''} data.input`
      @output = hexdigest_to_base64(File.read("#{dir}/data.input.hsh"))
      File.delete("#{dir}/data.input.hsh")
    end

    def create_sign
      `cd #{dir} && cryptcp -signf -#{container} -dn #{cert} -hashAlg 1.2.643.7.1.1.2.2 data.input`
      @output = File.read("#{dir}/data.input.sgn")
      File.delete("#{dir}/data.input.sgn")
    end

    def encr
      `cd #{dir} && cryptcp -encr -#{container} -dn #{cert} -encryptionAlg 1.2.643.7.1.1.2.2 data.input data.input.p7e`
      @output = File.read("#{dir}/data.input.p7e")
      File.delete("#{dir}/data.input.p7e")
    end

    def decr
      `cd #{dir} && cryptcp -decr -#{container} -dn #{cert} -start data.input data.output`
      @output = File.read("#{dir}/data.output")
      File.delete("#{dir}/data.output")
    end

    def list_cert
      @output = `certmgr -list -store #{container}`
    end

    def hexdigest_to_base64(hexdigest)
      [[hexdigest].pack('H*')].pack('m0')
    end
  end
end

