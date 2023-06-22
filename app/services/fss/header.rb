# frozen_string_literal: true

# Заголовок сообщения
class Fss::Header < Fss::Application
  require_relative '../crypto/application'
  require_relative './body'

  def call
    header
  end

  private

  def header
    @header ||= <<-XML
      <soapenv:Header>
        <wsse:Security soapenv:actor="http://eln.fss.ru/actor/mo/#{actor}" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
          <wsse:BinarySecurityToken EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3" wsu:Id="http://eln.fss.ru/actor/mo/#{ogrn}">
            #{binary_security_token}
          </wsse:BinarySecurityToken>
          <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
            <SignedInfo>
              <CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#WithComments"/>
              <SignatureMethod Algorithm="urn:ietf:params:xml:ns:cpxmlsec:algorithms:gostr34102012-gostr34112012-256"/>
              <Reference URI="#OGRN_#{ogrn}">
                <Transforms>
                  <Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#WithComments"/>
                </Transforms>
                <DigestMethod Algorithm="urn:ietf:params:xml:ns:cpxmlsec:algorithms:gostr34112012-256"/>
                <DigestValue>
                  #{digest_value}
                </DigestValue>
              </Reference>
            </SignedInfo>
            <SignatureValue>
              #{signature_value}
            </SignatureValue>
            <KeyInfo>
              <wsse:SecurityTokenReference>
                <wsse:Reference URI="#http://eln.fss.ru/actor/mo/#{ogrn}" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3"/>
              </wsse:SecurityTokenReference></KeyInfo>
            <object>
              <authority xmlns="urn:ru:fss:integration:types:signature:v01">
                <ns3:powerOfAttorneyLink xmlns:ns3="urn:ru:fss:integration:types:mchd:v01">
                  <ns3:uuid>
                    #{uuid}
                  </ns3:uuid>
                </ns3:powerOfAttorneyLink>
              </authority>
            </object>
          </Signature>
        </wsse:Security>
      </soapenv:Header>
    XML
  end

  def digest_value
    return @digest_value if @digest_value.present?

    value = Fss::Body.new(ogrn: ogrn, operation: operation).call
    canonicalize_value = Nokogiri::XML(value) { |config| config.strict }.canonicalize
    @digest_value = Crypto::Application.new(operation: :create_hash, input: canonicalize_value).call
    # @digest_value ||= 'VxP6uAm/bMwcjy2ZmiynC/H39+smHgnV7lkxiie7XOM='
  end

  def signature_value
    @signature_value = Crypto::Application.new(operation: :create_sign, input: digest_value).call
    # @signature_value ||= '8QBHez/cXldYeAN3VisqirD8SIkvEPqdGU/Qy5v0OlBT9Qm4R+m7bp9Q4zXmjwraS7VeBhyliauk515E2CKDhw=='
  end

  def uuid
    @uuid ||= '93ebd101-cc7e-4793-843f-065ee374b886'
  end

  def binary_security_token
    @binary_security_token ||= <<-HASH
      MIIJcTCCCRygAwIBAgIQAdV4RMhCEaAAAAFHA+gAAjAMBggqhQMHAQEDAgUAMIIB2DEYMBYGBSqF
      A2QBEg0xMDI3NzM5NDQzMjM2MT0wOwYDVQQJDDTQntGA0LvQuNC60L7QsiDQv9C10YDQtdGD0LvQ
      vtC6LCDQtC4gMywg0LrQvtGA0L8uINCQMRowGAYIKoUDA4EDAQESDDAwNzczNjA1NjY0NzELMAkG
      A1UEBhMCUlUxGTAXBgNVBAcMENCzLiDQnNC+0YHQutCy0LAxGDAWBgNVBAgMDzc3INCc0L7RgdC6
      0LLQsDEdMBsGCSqGSIb3DQEJARYOaW5mby11Y0Bmc3MucnUxZzBlBgNVBAoMXtCk0L7QvdC0INGB
      0L7RhtC40LDQu9GM0L3QvtCz0L4g0YHRgtGA0LDRhdC+0LLQsNC90LjRjyDQoNC+0YHRgdC40LnR
      gdC60L7QuSDQpNC10LTQtdGA0LDRhtC40LgxLjAsBgNVBAsMJdCm0LXQvdGC0YDQsNC70YzQvdGL
      0Lkg0LDQv9C/0LDRgNCw0YIxZzBlBgNVBAMMXtCk0L7QvdC0INGB0L7RhtC40LDQu9GM0L3QvtCz
      0L4g0YHRgtGA0LDRhdC+0LLQsNC90LjRjyDQoNC+0YHRgdC40LnRgdC60L7QuSDQpNC10LTQtdGA
      0LDRhtC40LgwHhcNMTkxMDAxMTA0MzAwWhcNMjEwMTAxMTA0MzAwWjCCAbkxGjAYBggqhQMDgQMB
      ARIMMDA3NzM2MDU2NjQ3MRgwFgYFKoUDZAESDTEwMjc3Mzk0NDMyMzYxLjAsBgNVBAsMJdCm0LXQ
      vdGC0YDQsNC70YzQvdGL0Lkg0LDQv9C/0LDRgNCw0YIxZzBlBgNVBAoMXtCk0L7QvdC0INGB0L7R
      htC40LDQu9GM0L3QvtCz0L4g0YHRgtGA0LDRhdC+0LLQsNC90LjRjyDQoNC+0YHRgdC40LnRgdC6
      0L7QuSDQpNC10LTQtdGA0LDRhtC40LgxPTA7BgNVBAkMNNCe0YDQu9C40LrQvtCyINC/0LXRgNC1
      0YPQu9C+0LosINC0LiAzLCDQutC+0YDQvy4g0JAxGTAXBgNVBAcMENCzLiDQnNC+0YHQutCy0LAx
      GDAWBgNVBAgMDzc3INCc0L7RgdC60LLQsDELMAkGA1UEBhMCUlUxZzBlBgNVBAMMXtCk0L7QvdC0
      INGB0L7RhtC40LDQu9GM0L3QvtCz0L4g0YHRgtGA0LDRhdC+0LLQsNC90LjRjyDQoNC+0YHRgdC4
      0LnRgdC60L7QuSDQpNC10LTQtdGA0LDRhtC40LgwZjAfBggqhQMHAQEBATATBgcqhQMCAiQABggq
      hQMHAQECAgNDAARAWE547ZGPxMp9MQeDCwvQyicAobxGamrrqzOFpabdEeDE3YGrQPjAIcTLp76E
      AAbvZV+u4XjjOXfrpMiwh5hiI4EJADAzRTgwMDAyo4IExzCCBMMwDgYDVR0PAQH/BAQDAgPYMB0G
      A1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAnBgNVHSAEIDAeMAgGBiqFA2RxATAIBgYqhQNk
      cQIwCAYGKoUDZHEDMDIGBSqFA2RvBCkMJ9Ca0YDQuNC/0YLQvtCf0YDQviBDU1Ag0LLQtdGA0YHQ
      uNGPIDQuMDCCAaAGBSqFA2RwBIIBlTCCAZEMb9Ch0YDQtdC00YHRgtCy0L4g0LrRgNC40L/RgtC+
      0LPRgNCw0YTQuNGH0LXRgdC60L7QuSDQt9Cw0YnQuNGC0Ysg0LjQvdGE0L7RgNC80LDRhtC40Lgg
      KNCh0JrQl9CYKSAiVmlQTmV0IENTUCA0Igxa0J/RgNC+0LPRgNCw0LzQvNC90YvQuSDQutC+0LzQ
      v9C70LXQutGBICJWaVBOZXQg0KPQtNC+0YHRgtC+0LLQtdGA0Y/RjtGJ0LjQuSDRhtC10L3RgtGA
      IDQiDFzQl9Cw0LrQu9GO0YfQtdC90LjQtSDQviDRgdC+0L7RgtCy0LXRgtGB0YLQstC40Lgg4oSW
      IDE0OS8zLzIvMi0yMDUyINC+0YIgMjkuMDEuMjAxNCDQs9C+0LTQsAxk0KHQtdGA0YLQuNGE0LjQ
      utCw0YIg0YHQvtC+0YLQstC10YLRgdGC0LLQuNGPIOKEliDQodCkLzEyOC0yOTMyINC+0YIgMTAg
      0LDQstCz0YPRgdGC0LAgMjAxNiDQs9C+0LTQsDAMBgNVHRMBAf8EAjAAMH8GCCsGAQUFBwEBBHMw
      cTBvBggrBgEFBQcwAoZjaHR0cDovL2UtdHJ1c3QuZ29zdXNsdWdpLnJ1L1NoYXJlZC9Eb3dubG9h
      ZENlcnQ/dGh1bWJwcmludD1CNjIzMDRCMTU0Qjk2NTk5MUYwMkQ0OThBM0UyN0M4M0YxMkE1RkMz
      MDUGA1UdHwQuMCwwKqAooCaGJGh0dHA6Ly9mc3MucnUvdWMvR1VDX0ZTU19SRl8yMDE5LmNybDCC
      AWAGA1UdIwSCAVcwggFTgBSVVLlVMbdsssTrKkJyGP7xZnjflqGCASykggEoMIIBJDEeMBwGCSqG
      SIb3DQEJARYPZGl0QG1pbnN2eWF6LnJ1MQswCQYDVQQGEwJSVTEYMBYGA1UECAwPNzcg0JzQvtGB
      0LrQstCwMRkwFwYDVQQHDBDQsy4g0JzQvtGB0LrQstCwMS4wLAYDVQQJDCXRg9C70LjRhtCwINCi
      0LLQtdGA0YHQutCw0Y8sINC00L7QvCA3MSwwKgYDVQQKDCPQnNC40L3QutC+0LzRgdCy0Y/Qt9GM
      INCg0L7RgdGB0LjQuDEYMBYGBSqFA2QBEg0xMDQ3NzAyMDI2NzAxMRowGAYIKoUDA4EDAQESDDAw
      NzcxMDQ3NDM3NTEsMCoGA1UEAwwj0JzQuNC90LrQvtC80YHQstGP0LfRjCDQoNC+0YHRgdC40LiC
      CwC1RWhKAAAAAAGfMCsGA1UdEAQkMCKADzIwMTkxMDAxMTA0MzAwWoEPMjAyMDEwMDExMDQzMDBa
      MBsGA1UdEQQUMBKBEGcucHJ5YW1vdkBmc3MucnUwHQYDVR0OBBYEFAryzW2jdIM8hWYyJf12iPSn
      N5iRMAwGCCqFAwcBAQMCBQADQQChumRyc4IqrADZN9NGvJBAYeEspDEMx06Gth6HvJMDAnaeps7I
      O5h39pPIcDKc5agj316WPHpHmkzG78i+U/RU
    HASH
  end
end
