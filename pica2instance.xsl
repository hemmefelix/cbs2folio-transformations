<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

  <xsl:template match="collection">
    <collection>
      <xsl:apply-templates />
    </collection>
  </xsl:template>

  <xsl:template match="record">
    <record>
      <xsl:apply-templates select="metadata"/>
    </record>
  </xsl:template>

  <xsl:template match="metadata">
    <source>FOLIO</source>
    <xsl:variable name="ppn" select="datafield[@tag='003@']/subfield[@code='0']" />
    <hrid>
      <xsl:value-of select="$ppn" />
    </hrid>

    <xsl:for-each select="datafield[@tag='001A']/subfield[@code='0']">
      <catalogedDate>
        <xsl:call-template name="pica-to-iso-date">
          <xsl:with-param name="input" select="." />
        </xsl:call-template>
      </catalogedDate>
    </xsl:for-each>

<!-- This will causes errors right now because createdDate also needs to be there
    <xsl:if test="datafield[@tag='001B']">
      <metadata>
        <xsl:for-each select="datafield[@tag='001B']">
          <updatedDate>
            <xsl:call-template name="pica-to-iso-date">
              <xsl:with-param name="input" select="subfield[@code='0']" />
              <xsl:with-param name="suffix" select="concat('T', subfield[@code='t'], 'Z')" />
            </xsl:call-template>
          </updatedDate>
        </xsl:for-each>
      </metadata>
    </xsl:if>
-->

    <xsl:for-each select="datafield[@tag='001D']/subfield[@code='0'][not(contains(.,'99-99'))]">
      <statusUpdatedDate>
        <xsl:call-template name="pica-to-iso-date">
          <xsl:with-param name="input" select="." />
        </xsl:call-template>
      </statusUpdatedDate>
    </xsl:for-each>

      <!-- There are more 1540 statistical codes in the spreadsheet for tag 002@. I'm not quite sure what to do about this -->
      <!-- <statisticalCodeIds>
        <arr>
          <xsl:for-each select="datafield[@tag='016B' or @tag='009N']"> 
            <i>
              <xsl:choose>
                <xsl:when test="subfield[@code='']='Aau'">UUID of Aau</xsl:when>
                <xsl:when test="subfield[@code='']='Aau'">UUID of Aau</xsl:when>
                <xsl:otherwise>b5968c9e-cddc-4576-99e3-8e60aed8b0dd</xsl:otherwise>
              </xsl:choose>
            </i>
          </xsl:for-each>
        </arr>
      </statisticalCodeIds> -->

    <xsl:if test="datafield[@tag='002@']">
      <!-- statusId -->
      <statusId>
        <xsl:variable name="stcode" select="substring(datafield[@tag='002@']/subfield[@code='0'], 3, 1)" /> 
        <xsl:choose>
          <xsl:when test="$stcode='u'">Autopsie</xsl:when>
          <xsl:when test="$stcode='v'">Bibliografisch vollständig</xsl:when>
          <xsl:when test="$stcode='a'">Erwerbungsdatensatz</xsl:when>
          <xsl:when test="$stcode='i'">Datensatz für internen Gebrauch</xsl:when>
          <xsl:when test="$stcode='k'">Lösch-Status</xsl:when>
          <xsl:when test="$stcode='n'">Maschinell konvertierte Daten</xsl:when>
          <xsl:when test="$stcode='r'">Katalogisat ohne Autopsie</xsl:when>
          <xsl:when test="$stcode='t'">Verwaltungsdatensatz</xsl:when>
          <xsl:when test="$stcode='x'">Fremddatensatz</xsl:when>
          <xsl:when test="$stcode='y'">Katalogisat nach Autopsie im Vorläufigkeitsstatus</xsl:when>
          <xsl:when test="$stcode='B'">Maschinelle Einspielung, möglicherweise dublett</xsl:when>
          <xsl:when test="$stcode='N'">Zunächst verdeckt eingespieltes Novum</xsl:when>
          <xsl:when test="$stcode='X'">Inhalt oder Struktur ist zu überprüfen</xsl:when>
        </xsl:choose>
      </statusId>
      <modeOfIssuanceId>
        <xsl:variable name="mii" select="substring(datafield[@tag='002@']/subfield[@code='0'], 2, 1)" />
        <xsl:variable name="noc" select="datafield[@tag='013D']/subfield[@code='9']" />
        <xsl:choose>
          <xsl:when test="($noc='106354256' or $noc='32609296X' or $noc='344907406' or $noc='153776951') and ($mii='a' or $mii='f' or $mii='F' or $mii='s' or $mii='v')">Integrierende Ressource</xsl:when>
          <xsl:when test="$mii='c'">f5cc2ab6-bb92-4cab-b83f-5a3d09261a41</xsl:when>
          <xsl:when test="$mii='b' or $mii='d'">068b5344-e2a6-40df-9186-1829e13cd344</xsl:when>
          <xsl:when test="$mii='z'">612bbd3d-c16b-4bfb-8517-2afafc60204a</xsl:when>
          <xsl:otherwise>9d18a02f-5897-4c31-9106-c9abb5c7ae8b</xsl:otherwise>
        </xsl:choose>
      </modeOfIssuanceId>
    </xsl:if>

    <!-- Instance type ID (resource type) -->
    <instanceTypeId>
      <!-- UUIDs for resource types -->
      <xsl:variable name="ctype" select="datafield[@tag='002C'][1]/subfield[@code='b']" />
      <xsl:choose>
        <xsl:when test="$ctype='crd'">3363cdb1-e644-446c-82a4-dc3a1d4395b9</xsl:when> <!-- cartographic dataset -->
        <xsl:when test="$ctype='cri'">526aa04d-9289-4511-8866-349299592c18</xsl:when> <!-- cartographic image -->
        <xsl:when test="$ctype='crm'">80c0c134-0240-4b63-99d0-6ca755d5f433</xsl:when> <!-- cartographic moving image -->
        <xsl:when test="$ctype='crt'">408f82f0-e612-4977-96a1-02076229e312</xsl:when> <!-- cartographic tactile image -->
        <xsl:when test="$ctype='crn'">e5136fa2-1f19-4581-b005-6e007a940ca8</xsl:when> <!-- cartographic tactile three-dimensional form -->
        <xsl:when test="$ctype='crf'">2022aa2e-bdde-4dc4-90bc-115e8894b8b3</xsl:when> <!-- cartographic three-dimensional form -->
        <xsl:when test="$ctype='cod'">df5dddff-9c30-4507-8b82-119ff972d4d7</xsl:when> <!-- computer dataset -->
        <xsl:when test="$ctype='cop'">c208544b-9e28-44fa-a13c-f4093d72f798</xsl:when> <!-- computer program -->
        <xsl:when test="$ctype='ntv'">fbe264b5-69aa-4b7c-a230-3b53337f6440</xsl:when> <!-- notated movement -->
        <xsl:when test="$ctype='ntm'">497b5090-3da2-486c-b57f-de5bb3c2e26d</xsl:when> <!-- notated music -->
        <xsl:when test="$ctype='prm'">3be24c14-3551-4180-9292-26a786649c8b</xsl:when> <!-- performed music -->
        <xsl:when test="$ctype='snd'">9bce18bd-45bf-4949-8fa8-63163e4b7d7f</xsl:when> <!-- sounds -->
        <xsl:when test="$ctype='spw'">c7f7446f-4642-4d97-88c9-55bae2ad6c7f</xsl:when> <!-- spoken word -->
        <xsl:when test="$ctype='sti'">535e3160-763a-42f9-b0c0-d8ed7df6e2a2</xsl:when> <!-- still image -->
        <xsl:when test="$ctype='tci'">efe2e89b-0525-4535-aa9b-3ff1a131189e</xsl:when> <!-- tactile image -->
        <xsl:when test="$ctype='tcn'">e6a278fb-565a-4296-a7c5-8eb63d259522</xsl:when> <!-- tactile notated movement -->
        <xsl:when test="$ctype='tcm'">a67e00fd-dcce-42a9-9e75-fd654ec31e89</xsl:when> <!-- tactile notated music -->
        <xsl:when test="$ctype='tct'">8105bd44-e7bd-487e-a8f2-b804a361d92f</xsl:when> <!-- tactile text -->
        <xsl:when test="$ctype='tcf'">82689e16-629d-47f7-94b5-d89736cf11f2</xsl:when> <!-- tactile three-dimensional form -->
        <xsl:when test="$ctype='txt'">6312d172-f0cf-40f6-b27d-9fa8feaf332f</xsl:when> <!-- text -->
        <xsl:when test="$ctype='tdf'">c1e95c2b-4efc-48cf-9e71-edb622cf0c22</xsl:when> <!-- three-dimensional form -->
        <xsl:when test="$ctype='tdm'">3e3039b7-fda0-4ac4-885a-022d457cb99c</xsl:when> <!-- three-dimensional moving image -->
        <xsl:when test="$ctype='tdi'">225faa14-f9bf-4ecd-990d-69433c912434</xsl:when> <!-- two-dimensional moving image -->
        <xsl:when test="$ctype='zzz'">30fffe0e-e985-4144-b2e2-1e8179bdb41f</xsl:when> <!-- unspecified -->
        <xsl:otherwise>a2c91e87-6bab-44d6-8adb-1fd02481fc4f</xsl:otherwise>  <!--  : other -->
      </xsl:choose>
    </instanceTypeId>

    <!-- Formats -->
    <instanceFormatIds>
      <arr>
        <xsl:for-each select="datafield[@tag='002E']">
          <i>
          <xsl:choose>
            <xsl:when test="./subfield[@code='b']='sg'">5642320a-2ab9-475c-8ca2-4af7551cf296</xsl:when> <!-- audio : audio cartridge -->
            <xsl:when test="./subfield[@code='b']='ss'">6d749f00-97bd-4eab-9828-57167558f514</xsl:when> <!-- audio : audiocassette -->
            <xsl:when test="./subfield[@code='b']='se'">485e3e1d-9f46-42b6-8c65-6bb7bd4b37f8</xsl:when> <!-- audio : audio cylinder -->
            <xsl:when test="./subfield[@code='b']='sd'">5cb91d15-96b1-4b8a-bf60-ec310538da66</xsl:when> <!-- audio : audio disc -->
            <xsl:when test="./subfield[@code='b']='sq'">7fde4e21-00b5-4de4-a90a-08a84a601aeb</xsl:when> <!-- audio : audio roll -->
            <xsl:when test="./subfield[@code='b']='st'">7612aa96-61a6-41bd-8ed2-ff1688e794e1</xsl:when> <!-- audio : audiotape reel -->
            <xsl:when test="./subfield[@code='b']='sw'">6a679992-b37e-4b57-b6ea-96be6b51d2b4</xsl:when> <!-- audio : audio wire reel -->
            <xsl:when test="./subfield[@code='b']='sz'">a3549b8c-3282-4a14-9ec3-c1cf294043b9</xsl:when> <!-- audio : other -->
            <xsl:when test="./subfield[@code='b']='si'">5bfb7b4f-9cd5-4577-a364-f95352146a56</xsl:when> <!-- audio : sound track reel -->
            <xsl:when test="./subfield[@code='b']='ck'">549e3381-7d49-44f6-8232-37af1cb5ecf3</xsl:when> <!-- computer : computer card -->
            <xsl:when test="./subfield[@code='b']='cb'">88f58dc0-4243-4c6b-8321-70244ff34a83</xsl:when> <!-- computer : computer chip cartridge -->
            <xsl:when test="./subfield[@code='b']='cd'">ac9de2b9-0914-4a54-8805-463686a5489e</xsl:when> <!-- computer : computer disc -->
            <xsl:when test="./subfield[@code='b']='ce'">e05f2613-05df-4b4d-9292-2ee9aa778ecc</xsl:when> <!-- computer : computer disc cartridge -->
            <xsl:when test="./subfield[@code='b']='ca'">f4f30334-568b-4dd2-88b5-db8401607daf</xsl:when> <!-- computer : computer tape cartridge -->
            <xsl:when test="./subfield[@code='b']='cf'">e5aeb29a-cf0a-4d97-8c39-7756c10d423c</xsl:when> <!-- computer : computer tape cassette -->
            <xsl:when test="./subfield[@code='b']='ch'">d16b19d1-507f-4a22-bb8a-b3f713a73221</xsl:when> <!-- computer : computer tape reel -->
            <xsl:when test="./subfield[@code='b']='cr'">f5e8210f-7640-459b-a71f-552567f92369</xsl:when> <!-- computer : online resource -->
            <xsl:when test="./subfield[@code='b']='cz'">fe1b9adb-e0cf-4e05-905f-ce9986279404</xsl:when> <!-- computer : other -->
            <xsl:when test="./subfield[@code='b']='ha'">cb3004a3-2a85-4ed4-8084-409f93d6d8ba</xsl:when> <!-- microform : aperture card -->
            <xsl:when test="./subfield[@code='b']='he'">fc3e32a0-9c85-4454-a42e-39fca788a7dc</xsl:when> <!-- microform : microfiche -->
            <xsl:when test="./subfield[@code='b']='hf'">b72e66e2-d946-4b01-a696-8fab07051ff8</xsl:when> <!-- microform : microfiche cassette -->
            <xsl:when test="./subfield[@code='b']='hb'">fc9bfed9-2cb0-465f-8758-33af5bba750b</xsl:when> <!-- microform : microfilm cartridge -->
            <xsl:when test="./subfield[@code='b']='hc'">b71e5ec6-a15d-4261-baf9-aea6be7af15b</xsl:when> <!-- microform : microfilm cassette -->
            <xsl:when test="./subfield[@code='b']='hd'">7bfe7e83-d4aa-46d1-b2a9-f612b18d11f4</xsl:when> <!-- microform : microfilm reel -->
            <xsl:when test="./subfield[@code='b']='hj'">cb96199a-21fb-4f11-b003-99291d8c9752</xsl:when> <!-- microform : microfilm roll -->
            <xsl:when test="./subfield[@code='b']='hh'">33009ba2-b742-4aab-b592-68b27451e94f</xsl:when> <!-- microform : microfilm slip -->
            <xsl:when test="./subfield[@code='b']='hg'">788aa9a6-5f0b-4c52-957b-998266ee3bd3</xsl:when> <!-- microform : microopaque -->
            <xsl:when test="./subfield[@code='b']='hz'">a0f2612b-f24f-4dc8-a139-89c3da5a38f1</xsl:when> <!-- microform : other -->
            <xsl:when test="./subfield[@code='b']='pp'">b1c69d78-4afb-4d8b-9624-8b3cfa5288ad</xsl:when> <!-- microscopic : microscope slide -->
            <xsl:when test="./subfield[@code='b']='pz'">55d3b8aa-304e-4967-8b78-55926d7809ac</xsl:when> <!-- microscopic : other -->
            <xsl:when test="./subfield[@code='b']='mc'">6bf2154b-df6e-4f11-97d0-6541231ac2be</xsl:when> <!-- projected image : film cartridge -->
            <xsl:when test="./subfield[@code='b']='mf'">47b226c0-853c-40f4-ba2e-2bd5ba82b665</xsl:when> <!-- projected image : film cassette -->
            <xsl:when test="./subfield[@code='b']='mr'">55a66581-3921-4b50-9981-4fe53bf35e7f</xsl:when> <!-- projected image : film reel -->
            <xsl:when test="./subfield[@code='b']='mo'">f0e689e8-e62d-4aac-b1c1-198ac9114aca</xsl:when> <!-- projected image : film roll -->
            <xsl:when test="./subfield[@code='b']='gd'">53f44ae4-167b-4cc2-9a63-4375c0ad9f58</xsl:when> <!-- projected image : filmslip -->
            <xsl:when test="./subfield[@code='b']='gf'">8e04d356-2645-4f97-8de8-9721cf11ccef</xsl:when> <!-- projected image : filmstrip -->
            <xsl:when test="./subfield[@code='b']='gc'">f7107ab3-9c09-4bcb-a637-368f39e0b140</xsl:when> <!-- projected image : filmstrip cartridge -->
            <xsl:when test="./subfield[@code='b']='mz'">9166e7c9-7edb-4180-b57e-e495f551297f</xsl:when> <!-- projected image : other -->
            <xsl:when test="./subfield[@code='b']='gt'">eb860cea-b842-4a8b-ab8d-0739856f0c2c</xsl:when> <!-- projected image : overhead transparency -->
            <xsl:when test="./subfield[@code='b']='gs'">b2b39d2f-856b-4419-93d3-ed1851f91b9f</xsl:when> <!-- projected image : slide -->
            <xsl:when test="./subfield[@code='b']='ez'">7c9b361d-66b6-4e4c-ae4b-2c01f655612c</xsl:when> <!-- stereographic : other -->
            <xsl:when test="./subfield[@code='b']='eh'">e62f4860-b3b0-462e-92b6-e032336ab663</xsl:when> <!-- stereographic : stereograph card -->
            <xsl:when test="./subfield[@code='b']='es'">c3f41d5e-e192-4828-805c-6df3270c1910</xsl:when> <!-- stereographic : stereograph disc -->
            <xsl:when test="./subfield[@code='b']='no'">5fa3e09f-2192-41a9-b4bf-9eb8aef0af0a</xsl:when> <!-- unmediated : card -->
            <xsl:when test="./subfield[@code='b']='nn'">affd5809-2897-42ca-b958-b311f3e0dcfb</xsl:when> <!-- unmediated : flipchart -->
            <xsl:when test="./subfield[@code='b']='nr'">926662e9-2486-4bb9-ba3b-59bd2e7f2a0c</xsl:when> <!-- unmediated : object -->
            <xsl:when test="./subfield[@code='b']='nz'">2802b285-9f27-4c86-a9d7-d2ac08b26a79</xsl:when> <!-- unmediated : other -->
            <xsl:when test="./subfield[@code='b']='na'">68e7e339-f35c-4be2-b161-0b94d7569b7b</xsl:when> <!-- unmediated : roll -->
            <xsl:when test="./subfield[@code='b']='nb'">5913bb96-e881-4087-9e71-33a43f68e12e</xsl:when> <!-- unmediated : sheet -->
            <xsl:when test="./subfield[@code='b']='nc'">8d511d33-5e85-4c5d-9bce-6e3c9cd0c324</xsl:when> <!-- unmediated : volume -->
            <xsl:when test="./subfield[@code='b']='zu'">98f0caa9-d38e-427b-9ec4-454de81a94d7</xsl:when> <!-- unspecified : unspecified -->
            <xsl:when test="./subfield[@code='b']='vz'">e3179f91-3032-43ee-be97-f0464f359d9c</xsl:when> <!-- video : other -->
            <xsl:when test="./subfield[@code='b']='vc'">132d70db-53b3-4999-bd79-0fac3b8b9b98</xsl:when> <!-- video : video cartridge -->
            <xsl:when test="./subfield[@code='b']='vf'">431cc9a0-4572-4613-b267-befb0f3d457f</xsl:when> <!-- video : videocassette -->
            <xsl:when test="./subfield[@code='b']='vd'">7f857834-b2e2-48b1-8528-6a1fe89bf979</xsl:when> <!-- video : videodisc -->
            <xsl:when test="./subfield[@code='b']='vr'">ba0d7429-7ccf-419d-8bfb-e6a1200a8d20</xsl:when> <!-- video : videotape reel -->
          </xsl:choose>
        </i>
        </xsl:for-each>
      </arr>
    </instanceFormatIds>

    <!-- Identifiers -->
    <identifiers>
      <arr>
      <xsl:for-each select="datafield[@tag='003S' or @tag='004A' or @tag='004P' or @tag='004J' or @tag='004K' or @tag='004D' 
      or @tag='005A' or @tag='005I' or @tag='005P' or @tag='005D' or @tag='004F' or @tag='004M' or @tag='004I' or @tag='006A'
      or @tag='006B' or @tag='006G' or @tag='006T' or @tag='006U' or @tag='006Z' or @tag='006S' or @tag='006L' or @tag='006'
      or @tag='006V' or @tag='006W' or @tag='006M' or @tag='004V' or @tag='004R' or @tag='004W' or @tag='004L' or @tag='004C'
      or @tag='004U' or @tag='003O' or @tag='003T' or @tag='003D' or @tag='007C' or @tag='007D' or @tag='007G']">
        <i>
          <xsl:choose>
            <xsl:when test="current()[@tag='004A' or @tag='004P' or @tag='005A' or @tag='005P' or @tag='005D' or @tag='004F' or @tag='004M' or @tag='004I']">
              <value>
                <xsl:choose>
                  <xsl:when test="./subfield[@code='f'] and ./subfield[@code='0']">
                    <xsl:value-of select="concat(./subfield[@code='0'],' ',./subfield[@code='f'])"/>
                  </xsl:when>
                  <xsl:when test="./subfield[@code='f']">
                    <xsl:value-of select="./subfield[@code='f']"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="./subfield[@code='0']"/> 
                  </xsl:otherwise>
                </xsl:choose>
              </value>
              <identifierTypeId>
                <xsl:choose>
                  <xsl:when test="current()/@tag='004A'">ISBN</xsl:when> <!-- ISBN -->
                  <xsl:when test="current()/@tag='004P' and ./subfield[@code='S']='a'">ISBN der parallelen Ausgabe auf einem anderen Datenträger</xsl:when>
                  <xsl:when test="current()/@tag='004P' and ./subfield[@code='S']='o'">ISBN der parallelen Ausgabe im Fernzugriff</xsl:when>
                  <xsl:when test="current()/@tag='004P' and ./subfield[@code='S']='p'">ISBN der parallelen Druckausgabe</xsl:when>
                  <xsl:when test="current()/@tag='004P' and ./subfield[@code='S']='u'">ISBN für parallele Ausgabe in einer anderen physischen Form</xsl:when>
                  <xsl:when test="current()/@tag='004P'">ISBN einer Manifestation in anderer physischer Form</xsl:when>
                  <xsl:when test="current()/@tag='005A'">ISSN</xsl:when> <!-- ISSN -->
                  <xsl:when test="current()/@tag='005D'">Formal falsche ISSN</xsl:when>
                  <xsl:when test="current()/@tag='005P' and ./subfield[@code='S']='a'">ISSN für parallele Ausgaben auf einem anderen Datenträger</xsl:when>
                  <xsl:when test="current()/@tag='005P' and ./subfield[@code='S']='o'">ISSN für parallele Ausgaben im Fernzugriff</xsl:when>
                  <xsl:when test="current()/@tag='005P' and ./subfield[@code='S']='p'">ISSN für parallele Druckausgaben</xsl:when>
                  <xsl:when test="current()/@tag='005P' and ./subfield[@code='S']='f'">fehlerhafte ISSN der parallelen Ausgabe</xsl:when>
                  <xsl:when test="current()/@tag='005P'">ISSN of parallel editions</xsl:when>
                  <xsl:when test="current()/@tag='004F'">ISMN</xsl:when>
                  <xsl:when test="current()/@tag='004M'">ISRN</xsl:when>
                  <xsl:when test="current()/@tag='004I'">Formal falsche ISMN</xsl:when>
                </xsl:choose>
              </identifierTypeId>
            </xsl:when>
            <xsl:when test="current()[@tag='007G' or @tag='007D']">
              <value>
                <xsl:choose>
                  <xsl:when test="./subfield[@code='0']">
                    <xsl:value-of select="concat(./subfield[@code='i'],': ',./subfield[@code='0'])" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="./subfield[@code='i']" />
                  </xsl:otherwise>
                </xsl:choose>
              </value>
              <identifierTypeId>
                <xsl:choose>
                  <xsl:when test="./@tag='007G'">Identnummer der erstkatalogisierenden Institution</xsl:when>
                  <xsl:otherwise>Publisher or distributor number</xsl:otherwise>
                </xsl:choose>
              </identifierTypeId>
            </xsl:when>
            <xsl:otherwise>
              <value>
                <xsl:value-of select="./subfield[@code='0']"/>
              </value>
              <identifierTypeId>
                <xsl:choose>
                  <xsl:when test="current()[@tag='003O']">OCLC</xsl:when>
                  <xsl:when test="current()[@tag='003S']">PPN SWB</xsl:when>
                  <xsl:when test="current()[@tag='004J']">ISBN der Reproduktion</xsl:when>
                  <xsl:when test="current()[@tag='004K']">Formal falsche ISBN der Reproduktion</xsl:when>
                  <xsl:when test="current()[@tag='004D']">Formal falsche ISBN</xsl:when>
                  <xsl:when test="current()[@tag='005I']">Autorisierte ISSN</xsl:when>
                  <xsl:when test="current()[@tag='006A']">LCCN</xsl:when>
                </xsl:choose>
              </identifierTypeId>
            </xsl:otherwise>
          </xsl:choose>
        </i>
      </xsl:for-each>
      </arr>
    </identifiers>

    <!-- title -->
    <xsl:variable name="title-tag">
      <xsl:choose>
        <xsl:when test="boolean(substring(datafield[@tag='002@']/subfield[@code='0'], 2, 1) = 'f')">036C</xsl:when>
        <xsl:otherwise>021A</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:for-each select="datafield[@tag=$title-tag]">
      <xsl:variable name="title-a" select="translate(./subfield[@code='a'], '@', '')" />
      <xsl:variable name="title-d" select="./subfield[@code='d']" />
      <xsl:variable name="title-h" select="./subfield[@code='h']" />
      <xsl:variable name="title-dx" select="substring-after(./subfield[@code='a'], '@')" />
      <xsl:variable name="title-l">
        <xsl:choose>
          <xsl:when test="./subfield[@code='l']"><xsl:value-of select="concat(' (', ./subfield[@code='l'], ')')"/></xsl:when>
          <xsl:otherwise />
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="title-f">
        <xsl:choose>
          <xsl:when test="./subfield[@code='f']"><xsl:value-of select="concat(' = ', ./subfield[@code='f'])"/></xsl:when>
          <xsl:otherwise />
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="title-p">
        <xsl:for-each select="../datafield[@tag='021C']">
          <xsl:value-of select="normalize-space(concat(./subfield[@code='l'], ' ', ./subfield[@code='a']))" /> 
            <xsl:if test="position() != last()">
              <xsl:value-of select="string('. ')" />
            </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <indexTitle>
        <xsl:choose>
          <xsl:when test="$title-dx">
            <xsl:value-of select="normalize-space(concat($title-dx, ' ', $title-d, ' ', $title-h))" /> 
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(concat($title-a, ' ', $title-d, ' ', $title-h))" />
          </xsl:otherwise>
        </xsl:choose>
      </indexTitle>
      <xsl:variable name="main-title">
        <xsl:choose>
          <xsl:when test="string($title-h) and string($title-d) and string($title-p)"><xsl:value-of select="concat($title-a, '. ', $title-p, ' : ', $title-d, $title-f, ' / ', $title-h)" /></xsl:when>
          <xsl:when test="string($title-h) and string($title-d)"><xsl:value-of select="concat($title-a, ' : ', $title-d, $title-f, ' / ', $title-h)" /></xsl:when>
          <xsl:when test="string($title-d) and string($title-p)"><xsl:value-of select="concat($title-a, '. ', $title-p, ' : ', $title-d, $title-f)" /></xsl:when>
          <xsl:when test="string($title-h) and string($title-p)"><xsl:value-of select="concat($title-a, $title-f, '. ', $title-p, ' / ', $title-h)" /></xsl:when>
          <xsl:when test="string($title-d)"><xsl:value-of select="concat($title-a, ' : ', $title-d, $title-f)" /></xsl:when>
          <xsl:when test="string($title-h)"><xsl:value-of select="concat($title-a, $title-f, ' / ', $title-h)" /></xsl:when>
          <xsl:when test="string($title-p)"><xsl:value-of select="concat($title-a, $title-f, '. ', $title-p)" /></xsl:when>
          <xsl:otherwise><xsl:value-of select="concat($title-a, $title-f)" /></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <title>
        <xsl:value-of select="concat($main-title,$title-l)" />
      </title>
    </xsl:for-each>

    <matchKey>
        <!-- Only fields that are actually included in
              the instance somewhere - for example in 'title' -
              should be included as 'matchKey' elements lest
              the instance "magically" splits on "invisible"
              properties.
        <name-of-part-section-of-work>
          <xsl:value-of select="marc:subfield[@code='p']" />
        </name-of-part-section-of-work>
        <number-of-part-section-of-work>
          <xsl:value-of select="marc:subfield[@code='n']" />
        </number-of-part-section-of-work>
        <inclusive-dates>
          <xsl:value-of select="marc:subfield[@code='f']" />
        </inclusive-dates> -->
    </matchKey>

    <!-- Contributors -->
    <xsl:if test="datafield[@tag='028A' or @tag='028B' or @tag='028C' or @tag='028G' or @tag='029A']">
      <contributors>
        <arr>
          <xsl:for-each select="datafield[@tag='028A' or @tag='028B' or @tag='028C' or @tag='028G']">
            <xsl:if test="subfield[@code='a' or @code='A' or @code='P' or @code='8']">
              <i>
                <name>
                  <xsl:choose>
                    <xsl:when test="./subfield[@code='8']"><xsl:value-of select="substring-before(./subfield[@code='8'], ' ; ID:')" /></xsl:when>
                    <xsl:when test="./subfield[@code='P']"><xsl:value-of select="./subfield[@code='P']" /></xsl:when>
                    <xsl:when test="./subfield[@code='d' or @code='D']">
                      <xsl:variable name='name' select="concat(./subfield[@code='a' or @code='A'], ', ', ./subfield[@code='d' or @code='D'])" />
                      <xsl:choose>
                        <xsl:when test="./subfield[@code='c' or @code='C']"><xsl:value-of select="concat($name, ' ', ./subfield[@code='c' or @code='C'])" /></xsl:when>
                        <xsl:when test="./subfield[@code='n' or @code='N']"><xsl:value-of select="concat($name, ', ', ./subfield[@code='n' or @code='N'])" /></xsl:when>
                        <xsl:when test="./subfield[@code='l' or @code='L']"><xsl:value-of select="concat($name, ' &lt;', ./subfield[@code='l' or @code='L'], '&gt;')" /></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$name"></xsl:value-of></xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="./subfield[@code='a' or @code='A']" /></xsl:otherwise>
                  </xsl:choose>
                </name>
                <contributorNameTypeId>2b94c631-fca9-4892-a730-03ee529ffe2a</contributorNameTypeId> <!-- personal name -->
                <xsl:if test="@tag='028A'">
                  <primary>true</primary>
                </xsl:if>
                <xsl:if test="./subfield[@code='4']">
                  <contributorTypeId><xsl:value-of select="./subfield[@code='4']"></xsl:value-of></contributorTypeId>
                </xsl:if>
              </i>
            </xsl:if>
          </xsl:for-each> 

          <!-- Corporate authors-->
          <xsl:for-each select="datafield[@tag='029A' or @tag='029F']">
            <xsl:variable name="cpa" select="./subfield[@code='a' or @code='A']" />
            <xsl:variable name="cpx" select="./subfield[@code='x' or @code='X']" />
            <xsl:variable name="cpg" select="./subfield[@code='g' or @code='G']" />
            <xsl:variable name="cpb">
              <xsl:call-template name="join">
                <xsl:with-param name="list" select="./subfield[@code='b' or @code='B']" />
                <xsl:with-param name="separator" select="' / '" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="cpn">
              <xsl:call-template name="join">
                <xsl:with-param name="list" select="./subfield[@code='n' or @code='N']" />
                <xsl:with-param name="separator" select="', '" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="cpd">
              <xsl:call-template name="join">
                <xsl:with-param name="list" select="./subfield[@code='d' or @code='D']" />
                <xsl:with-param name="separator" select="' ; '" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="cpc">
              <xsl:call-template name="join">
                <xsl:with-param name="list" select="./subfield[@code='c' or @code='C']" />
                <xsl:with-param name="separator" select="' ; '" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="lash" select="' / '" />
            <i>
              <name>
                <xsl:choose>
                  <xsl:when test="./subfield[@code='8']"><xsl:value-of select="substring-before(./subfield[@code='8'], ' ; ID:')" /></xsl:when>
                  <xsl:when test="$cpa and string($cpb) and string($cpg) and string($cpx) and string($cpn) and string($cpd) and string($cpc)">
                    <xsl:value-of select="concat($cpa,$lash,$cpb,$lash,$cpg,$lash,$cpx,' (',$cpn,') : ',$cpd,$lash,$cpc)"></xsl:value-of>
                  </xsl:when>
                  <xsl:when test="$cpa and string($cpb) and string($cpg) and string($cpn) and string($cpd) and string($cpc)">
                    <xsl:value-of select="concat($cpa,$lash,$cpb,$lash,$cpg,' (',$cpn,') : ',$cpd,$lash,$cpc)"></xsl:value-of>
                  </xsl:when>
                  <xsl:when test="$cpa and string($cpb) and string($cpn) and string($cpd) and string($cpc)">
                    <xsl:value-of select="concat($cpa,$lash,$cpb,' (',$cpn,') : ',$cpd,$lash,$cpc)"></xsl:value-of>
                  </xsl:when>
                  <xsl:when test="$cpa and string($cpb) and string($cpg)">
                    <xsl:value-of select="concat($cpa,$lash,$cpb,$lash,$cpg)"></xsl:value-of>
                  </xsl:when>
                  <xsl:when test="$cpa and string($cpg)">
                    <xsl:value-of select="concat($cpa,$lash,$cpg)"></xsl:value-of>
                  </xsl:when>
                  <xsl:when test="$cpa and string($cpb)">
                    <xsl:value-of select="concat($cpa,$lash,$cpb)"></xsl:value-of>
                  </xsl:when>
                  <xsl:when test="string($cpb)">
                    <xsl:value-of select="$cpb"></xsl:value-of>
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="$cpa" /></xsl:otherwise>
                </xsl:choose>
              </name>
              <contributorNameTypeId>2e48e713-17f3-4c13-a9f8-23845bb210aa</contributorNameTypeId>
              <xsl:if test="./subfield[@code='4']">
                  <contributorTypeId><xsl:value-of select="./subfield[@code='4']"></xsl:value-of></contributorTypeId>
              </xsl:if>
            </i>
          </xsl:for-each>
        </arr>
      </contributors>
    </xsl:if>

    <!-- Editions -->

    <!-- Publication -->
    <xsl:for-each select="datafield[@tag='033A']">
      <publication>
        <arr>
          <i>
            <publisher>
              <xsl:value-of select="./subfield[@code='n']"></xsl:value-of>
            </publisher>
            <place>
              <xsl:value-of select="./subfield[@code='p']"></xsl:value-of>
            </place>
            <xsl:if test="..//datafield[@tag='011@']">
              <dateOfPublication>
                <xsl:variable name="date-a" select="../datafield[@tag='011@']/subfield[@code='a']" />
                <xsl:variable name="date-b" select="../datafield[@tag='011@']/subfield[@code='b']" />
                <xsl:variable name="date-c" select="../datafield[@tag='011@']/subfield[@code='c']" />
                <xsl:variable name="date-d" select="../datafield[@tag='011@']/subfield[@code='d']" />
                <xsl:variable name="date-n" select="../datafield[@tag='011@']/subfield[@code='n']" />
                <xsl:variable name="date-ab" select="concat($date-a, '-', $date-b)" />
                <xsl:variable name="date-cd" select="concat($date-c, '-', $date-d)" />
                <xsl:variable name="date-ac" select="concat($date-a, ' (', $date-c, ')')" />
                <xsl:variable name="date-abcd" select="concat($date-ab, ' (', $date-cd, ')')" />
                <xsl:choose>
                  <xsl:when test="$date-d and $date-n"><xsl:value-of select="concat($date-abcd, ' (', $date-n, ')')" /></xsl:when> 
                  <xsl:when test="$date-d"><xsl:value-of select="$date-abcd" /></xsl:when>
                  <xsl:when test="$date-c and $date-n"><xsl:value-of select="concat($date-ac, ' (', $date-n, ')')" /></xsl:when> 
                  <xsl:when test="$date-c"><xsl:value-of select="$date-ac" /></xsl:when>
                  <xsl:when test="$date-b and $date-n"><xsl:value-of select="concat($date-ab, ' (', $date-n, ')')" /></xsl:when> 
                  <xsl:when test="$date-b"><xsl:value-of select="$date-ab" /></xsl:when>
                  <xsl:when test="$date-a and $date-n"><xsl:value-of select="concat($date-a, ' (', $date-n, ')')" /></xsl:when> 
                  <xsl:otherwise><xsl:value-of select="$date-a"/></xsl:otherwise>
                </xsl:choose>
              </dateOfPublication>
            </xsl:if>
          </i>
        </arr>
      </publication>
    </xsl:for-each>

    <xsl:if test="datafield[@tag='011B']">
      <notes>
        <arr>
          <xsl:for-each select="datafield[@tag='011B']">
            <i>
                <xsl:choose>
                  <xsl:when test="./@tag='011B'">
                    <note>
                      <xsl:if test="./subfield[@code='b']">
                        <xsl:value-of select="concat(./subfield[@code='a'], '-', ./subfield[@code='b'])" />
                      </xsl:if>
                      <xsl:if test="not(./subfield[@code='b'])">
                        <xsl:value-of select="./subfield[@code='a']" />
                      </xsl:if>
                    </note>
                    <instanceNoteTypeId>d548fdff-b71c-4359-8055-f1c008c30f01</instanceNoteTypeId> <!-- reproduction note -->
                  </xsl:when>
                </xsl:choose>
            </i>
          </xsl:for-each>
        </arr>
      </notes>
    </xsl:if>

    <!-- Nature of conents (can't find any examples for testing puposes) -->
    <xsl:if test="datafield[@tag='013']/subfield[@code='8']">
      <natureOfContentTermIds>
        <arr>
          <i>nature of contents</i>
        </arr>
      </natureOfContentTermIds>
    </xsl:if>

    <!-- languages -->
    <xsl:if test="datafield[@tag='010@']/subfield[@code='a']">
      <languages>
        <arr>
          <xsl:for-each select="datafield[@tag='010@']/subfield[@code='a']">
            <i>
              <xsl:value-of select="." />
            </i>
          </xsl:for-each>
        </arr>
      </languages>
    </xsl:if>

    <!-- physicalDescriptions -->

    <xsl:if test="datafield[@tag='034D' or @tag='034M' or @tag='034I' or @tag='034K']">
      <xsl:variable name="phd"><xsl:value-of select="datafield[@tag='034D']/subfield[@code='a']" /></xsl:variable>
      <xsl:variable name="phm"><xsl:value-of select="datafield[@tag='034M']/subfield[@code='a']" /></xsl:variable>
      <xsl:variable name="phi"><xsl:value-of select="datafield[@tag='034I']/subfield[@code='a']" /></xsl:variable>
      <xsl:variable name="phk"><xsl:value-of select="datafield[@tag='034K']/subfield[@code='a']" /></xsl:variable>
      <physicalDescriptions>
        <arr>
          <i>
            <xsl:choose>
              <xsl:when test="$phd and string($phm) and string($phi) and string($phk)">
                <xsl:value-of select="concat($phd, ' : ', $phm, ' ; ', $phi, ' + ', $phk)" />
              </xsl:when>
              <xsl:when test="$phd and string($phm) and string($phi)">
                <xsl:value-of select="concat($phd, ' : ', $phm, ' ; ', $phi)" />
              </xsl:when>
              <xsl:when test="$phd and string($phm)">
                <xsl:value-of select="concat($phd, ' : ', $phm)" />
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="$phd" /></xsl:otherwise>
            </xsl:choose>
          </i>
        </arr>
      </physicalDescriptions>
    </xsl:if>

    <!-- Subjects -->

    <xsl:if test="item/datafield[@tag='203@']/subfield[@code='0'] | datafield[@tag='109R']">
      <holdingsRecords>
        <arr>
          <xsl:apply-templates select="item"/>

          <!-- Electronic access -->
          <xsl:if test="datafield[@tag='109R']/subfield[@code='u']">
            <i>
              <hrid><xsl:value-of select="$ppn" /></hrid>
              <permanentLocationId>Zentrale Leihtheke</permanentLocationId> <!-- hardcoded : where to find in item record? --> 
              <electronicAccess>
                <arr>
                  <xsl:for-each select="datafield[@tag='109R']">
                    <i>
                      <uri>
                        <xsl:value-of select="./subfield[@code='u']" />
                      </uri>
                    </i>
                  </xsl:for-each>
                </arr>
              </electronicAccess>
            </i>
          </xsl:if>
        </arr>
      </holdingsRecords>
    </xsl:if>
  </xsl:template>

  <xsl:template match="item">
    <i>
      <xsl:variable name="hhrid" select="datafield[@tag='203@']/subfield[@code='0']" />
      <hrid><xsl:value-of select="$hhrid" /></hrid>
      <permanentLocationId>Zentrale Leihtheke</permanentLocationId> <!-- hardcoded : where to find in item record? -->
      <callNumber><xsl:value-of select="datafield[@tag='209A']/subfield[@code='a']" /></callNumber>
      <items>
        <arr>
          <i>
            <hrid><xsl:value-of select="$hhrid" /></hrid>
            <materialTypeId>book</materialTypeId> <!-- hardcoded : where to find in item record? -->
            <permanentLoanTypeId>
              <xsl:variable name="loantype" select="datafield[@tag='209@']/subfield[@code='d']"></xsl:variable>
              <xsl:choose>
                <xsl:when test="u">ausleihbar/Fernleihe</xsl:when>
                <xsl:when test="b">verkürzt ausleihbar/Fernleihe</xsl:when>
                <xsl:when test="c">ausleihbar/keine Fernleihe</xsl:when>
                <xsl:when test="s">mit Zustimmung ausleihbar/nur Kopie in die Fernleihe</xsl:when>
                <xsl:when test="d">mit Zustimmung ausleihbar/Fernleihe</xsl:when>
                <xsl:when test="i">Lesesaalausleihe/keine Fernleihe</xsl:when>
                <xsl:when test="f">Lesesaalausleihe/nur Kopie in die Fernleihe</xsl:when>
                <xsl:when test="g">für die Ausleihe gesperrt/keine Fernleihe</xsl:when>
                <xsl:when test="a">bestellt/keine Fernleihe</xsl:when>
                <xsl:when test="o">keine Angabe/keine Fernleihe</xsl:when>
                <xsl:when test="z">Verlust/keine Fernleihe</xsl:when>
                <xsl:otherwise>Normal / Can circulate</xsl:otherwise>
              </xsl:choose>
            </permanentLoanTypeId>
            <status>
              <name>Available</name>
            </status>
            <itemLevelCallNumber><xsl:value-of select="datafield[@tag='209A']/subfield[@code='a']" /></itemLevelCallNumber>
            <barcode>
              <xsl:value-of select="datafield[@tag='209G']/subfield[@code='a']" />
            </barcode>
          </i>
        </arr>
      </items>
    </i>
  </xsl:template>

  <xsl:template match="text()" />

  <xsl:template name="join">
    <xsl:param name="list" />
    <xsl:param name="separator"/>
    <xsl:for-each select="$list">
      <xsl:value-of select="." />
      <xsl:if test="position() != last()">
          <xsl:value-of select="$separator" />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="pica-to-iso-date">
    <xsl:param name="input" />
    <xsl:param name="suffix" />
    <xsl:variable name="rawdate" select="substring-after($input, ':')" />
    <xsl:variable name="day" select="substring-before($rawdate, '-')" />
    <xsl:variable name="moyr" select="substring-after($rawdate, '-')" />
    <xsl:variable name="month" select="substring-before($moyr, '-')" />
    <xsl:variable name="shortyear" select="substring-after($moyr, '-')" />
    <xsl:if test="$shortyear &gt; 50">
      <xsl:variable name="year" select="concat('19', $shortyear)" />
      <xsl:value-of select="concat($year, '-', $month, '-', $day, $suffix)" />
    </xsl:if>
    <xsl:if test="$shortyear &lt; 51">
      <xsl:variable name="year" select="concat('20', $shortyear)" />
      <xsl:value-of select="concat($year, '-', $month, '-', $day, $suffix)" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="remove-characters-last">
    <xsl:param name="input" />
    <xsl:param name="characters"/>
    <xsl:variable name="lastcharacter" select="substring($input,string-length($input))" />
    <xsl:choose>
      <xsl:when test="$characters and $lastcharacter and contains($characters, $lastcharacter)">
        <xsl:call-template name="remove-characters-last">
          <xsl:with-param  name="input" select="substring($input,1, string-length($input)-1)" />
          <xsl:with-param  name="characters" select="$characters" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$input"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
