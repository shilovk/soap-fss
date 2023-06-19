# frozen_string_literal: true

module Fss
  class Application
    WSDL = 'https://eln-test.fss.ru/WSLnV20/FileOperationsLnService?WSDL'

    attr_reader :client
    attr_accessor :xml_data

    def initialize
      @client = Savon.client(wsdl: self.class.const_get('WSDL'))
    end

    def operations
      @operations ||= client.operations

      # [:pr_parse_filelnlpu,
      #  :get_ln_list_by_date,
      #  :get_ln_list_by_snils,
      #  :get_existing_ln_num_range,
      #  :get_new_ln_num,
      #  :get_new_ln_num_range,
      #  :get_ln_data,
      #  :disable_ln]
    end
  end
end

