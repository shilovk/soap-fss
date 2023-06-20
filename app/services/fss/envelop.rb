# frozen_string_literal: true

# Сообщение
class Fss::Envelop < Fss::Application
  def call
    envelop
  end

  private

  def envelop
    @envelop ||= <<-XML
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:v01="http://www.fss.ru/integration/types/eln/mo/v01" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
        #{header}
        #{body}
      </soapenv:Envelope>
    XML
  end

  def header
    @header = Fss::Header.new(actor: actor, ogrn: ogrn).call
  end

  def body
    @body = Fss::Body.new(ogrn: ogrn, operation: operation).call
  end
end

"      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" xmlns:v01=\"http://www.fss.ru/integration/types/eln/mo/v01\" xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\">\n              <soapenv:Header>\n        <wsse:Security soapenv:actor=\"http://eln.fss.ru/actor/mo/1027739443236\" xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\">\n          <wsse:BinarySecurityToken EncodingType=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary\" ValueType=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3\" wsu:Id=\"http://eln.fss.ru/actor/mo/1027500716143\">\n            \n          </wsse:BinarySecurityToken>\n          <Signature xmlns=\"http://www.w3.org/2000/09/xmldsig#\">\n            <SignedInfo>\n              <CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#WithComments\"/>\n              <SignatureMethod Algorithm=\"urn:ietf:params:xml:ns:cpxmlsec:algorithms:gostr34102012-gostr34112012-256\"/>\n              <Reference URI=\"#OGRN_1027500716143\">\n                <Transforms>\n                  <Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#WithComments\"/>\n                </Transforms>\n                <DigestMethod Algorithm=\"urn:ietf:params:xml:ns:cpxmlsec:algorithms:gostr34112012-256\"/>\n                <DigestValue>\n                  \n                </DigestValue>\n              </Reference>\n            </SignedInfo>\n            <SignatureValue>\n              \n            </SignatureValue>\n            <KeyInfo>\n              <wsse:SecurityTokenReference>\n                <wsse:Reference URI=\"#http://eln.fss.ru/actor/mo/1027500716143\" ValueType=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3\"/>\n              </wsse:SecurityTokenReference></KeyInfo>\n            <object>\n              <authority xmlns=\"urn:ru:fss:integration:types:signature:v01\">\n                <ns3:powerOfAttorneyLink xmlns:ns3=\"urn:ru:fss:integration:types:mchd:v01\">\n                  <ns3:uuid>\n                    \n                  </ns3:uuid>\n                </ns3:powerOfAttorneyLink>\n              </authority>\n            </object>\n          </Signature>\n        </wsse:Security>\n      </soapenv:Header>\n\n              <soapenv:Body wsu:Id=\"OGRN_1027500716143\">\n              <v01:getNewLNNumRequest>\n          <v01:ogrn>\n            1027500716143\n          </v01:ogrn>\n      </v01:getNewLNNumRequest>\n\n      </soapenv:Body>\n\n      </soapenv:Envelope>\n"
