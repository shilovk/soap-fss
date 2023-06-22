# frozen_string_literal: true

# Генерация сообщений xml и отправка через soap в ФСС
# reload!; Fss::Application.new(actor: '1027739443236', ogrn: '1027500716143', operation: :get_new_ln_num).call.body
module Fss
  class Application
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

    private

    def response
      @response ||= client.call(operation, message: canonicalize_envelop)
    end

    def client
      @client ||= Savon.client(wsdl: self.class.const_get('WSDL'))
    end


    def envelop
      @envelop ||= Fss::Envelop.new(actor: actor, ogrn: ogrn, operation: operation).call
      File.write("#{Rails.root}/public/xml/generate/#{operation}.xml", @envelop)
      @envelop
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

