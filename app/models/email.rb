class Email < ActiveRecord::Base
  require 'csv'

  belongs_to :cluster
  validates :email_domain, presence: true

#constants
    DISTICTDOMAINSCOUNT = Email.select("email_domain").distinct.count
    DISTICTDOMAINSBRIDGE = Email.select("email_domain, bridge").distinct.order('bridge ASC')
    DISTINCTBRIDGECOUNT = Email.select("bridge").distinct.count
    DISTINCTEMAIL = Email.count
    BRIDGENAMES = ['Not Yet Classified','Capital','Company','Research','Public Sector', 'Cluster','Global Market','Education','Junk']
    BRIDGEVALUE = [0, 1, 2,3,4,5,6,7,8]
    MINCONTACT = 4
    MONTHNAMESMODEL = ["0","Jan","Feb","Mar", "Apr", "May", "Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    MONTHVALUESMODEL =  [1,2,3,4,5,6,7,8,9,10,11,12]

#query filters - using scopes with
#example scopes
#scope :with_skill, -> (skill){ joins(:pokemon_skills).where("pokemon_skills.name = ?", skill) }
#scope :by_month, -> (month){ where("'month' = ?", month) }

      #bridge filter removes non-essential bridges (junk, misc and non-categorized from the charting queries)
      scope :bridge_filter, lambda{ where("bridge <> '9999' AND bridge <> 9998 AND bridge <> '0'")}
      # groups by month, orders by month, summing email frequency.
      scope :gr_month_or_month_su_frequency, lambda{ group('month').order('month ASC').sum('email_frequency')}
      #groups and orders by bridge bridge the total frequency
      scope :gr_bridge_or_bridge_su_frequency, lambda{ group('bridge').order('bridge ASC').sum('email_frequency')}

      #averages by bridge and month
      scope :gr_bridge_or_bridge_av_frequency, lambda{ group('bridge').order('bridge ASC').average('email_frequency')}
      scope :gr_month_or_month_av_frequency, lambda{ group('month').order('month ASC').average('email_frequency')}

      scope :bridge_month, -> (bridge_value){ where("bridge = ?", bridge_value).gr_month_or_month_su_frequency}
  #  @totalCategory1byMonth = EmailAggregate.where("category = '1'").group('month').order('month ASC').sum('frequency')
      scope :email_total, -> (month_value){ where("month = '?'", month_value).bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency}

  #scopes with cluster and year
      #total contact by month, bar chart
      scope :total_contact_month_year_cluster, ->(month_value, year_value, cluster_value){ where("month ='?'", month_value).where("year='?'", year_value).where("cluster_id ='?'", cluster_value).bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency}

      #Total Volume by month, bridge volume stacked chart
      scope :total_bridge_year_cluster, ->(bridge_value, year_value, cluster_value){ where("bridge = '?'", bridge_value).where("year ='?'", year_value).where("cluster_id ='?'", cluster_value).where("email_frequency >='?'", Email::MINCONTACT).group('month').order('month ASC').sum('email_frequency')}
      # stacked_bar is used in the stacked chart the above is not functional.
      scope :stacked_bar, ->(bridge_value, year_value, cluster_value){where("bridge = '?'", bridge_value).where("year = '?'", year_value).where("cluster_id = '?'", cluster_value).gr_month_or_month_su_frequency}

      #diversity calc
      scope :diversity_metric, -> (month_value, year_value, cluster_value){where("month = '?'", month_value).where("year = '?'", year_value).where("cluster_id ='?'", cluster_value).where("bridge <> '0' AND bridge <> '9999' AND bridge <> '9998'").select("email_domain").group("bridge").order("bridge").distinct.count}


      #Average intensity by month, barchart for each month
      scope :average_intensity_year_cluster, ->(bridge_value, month_value, year_value, cluster_value){ where("bridge ='?'", bridge_value).where("month ='?'", month_value).where("year='?'", year_value).where("cluster_id ='?'", cluster_value).average("email_frequency")}
      scope :sum_intensity_year_cluster, ->(bridge_value, month_value, year_value, cluster_value){ where("bridge ='?'", bridge_value).where("month ='?'", month_value).where("year='?'", year_value).where("cluster_id ='?'", cluster_value).sum("email_frequency")}

      scope :average_intensity, ->(bridge_value, month_value){ where("bridge ='?'", bridge_value).where("month ='?'", month_value).average("email_frequency")}
      # groups by month and orders by month the sum of freqencies.



      def self.to_csv(options ={})
        CSV.generate(options) do |csv|
            csv << column_names
              all.each do |email|
                csv << email.attributes.values_at(*column_names)
          end
        end
      end

      #import CSV and set value
      def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
          row.to_hash
          row[:bridge] = DOMAINHASH.fetch((row.to_hash[:email_domain.to_s]),0)
          #row[:email_domain] = (((row.to_hash)[:email_domain.to_s]) + "added")
          Email.create! row.to_hash
        end
      end

DOMAINHASH =  {"126.com"=>9999,
"163.com"=>9999,
"4itab.com"=>2,
"60photos.com"=>9999,
"7lab.se"=>9999,
"abe.kth.se"=>3,
"abilitypartner.se"=>2,
"acreo.se"=>3,
"adlibris.anpdm.com"=>9999,
"aerogel.se"=>2,
"aftonbladet.se"=>9999,
"agima.se"=>2,
"aginova.com"=>6,
"aiaiindia.com"=>9999,
"aliexpress.com"=>9999,
"alltforforaldrar.net"=>9999,
"almi.se"=>1,
"alvkarleby.se"=>4,
"anido.se"=>2,
"anutanetworks.com"=>6,
"apac.esprit-club.com"=>9999,
"appcelerator.com"=>9999,
"arekonferens.se"=>9999,
"a-relation.se"=>2,
"arneblom.se"=>2,
"aronssons.se"=>2,
"aurasma.com"=>6,
"avdrag.se"=>9999,
"b2match.eu"=>9999,
"babyproffsen.se"=>9999,
"balnor.se"=>2,
"bastsaljaren.se"=>9999,
"bellevue.edu"=>6,
"bigtravel.se"=>9999,
"BIGTRAVEL.SE"=>9999,
"billerudkorsnas.com"=>2,
"bioinspiredforum.com"=>4,
"biosystem.se"=>2,
"bke.se"=>9999,
"blabsweden.com"=>2,
"blabsweden.se"=>2,
"blinfo.se"=>9999,
"bokus.anpdm.com"=>9999,
"bollnasenergi.se"=>4,
"bravofly.bravoflygroup.com"=>9999,
"briantracyintl.com"=>9999,
"bridge-innovation.com"=>6,
"brobygrafiska.se"=>3,
"brynas.se"=>2,
"bsei.com.cn"=>6,
"business-sweden.se"=>4,
"buzz-tech.com"=>9999,
"calaha.se"=>2,
"calligraphen.se"=>9999,
"carmenta.com"=>2,
"cartesia.se"=>2,
"ce.org"=>2,
"cebexgroup.com"=>2,
"cehis.se"=>5,
"centralsweden.be"=>4,
"chillawear.se"=>9999,
"choice.no"=>9999,
"choice.se"=>9999,
"cicograf.se"=>9999,
"cision.com"=>9999,
"cluster55.org"=>5,
"cluster-development.com"=>5,
"clusterland.at"=>5,
"coffeecenter.se"=>9999,
"communication.istockphoto.com"=>9999,
"compare.se"=>5,
"coolstuff.se"=>9999,
"coompanion.se"=>5,
"coor.com"=>2,
"copperberg.com"=>9999,
"coresource.se"=>9999,
"crcsi.com.au"=>6,
"cromea.se"=>2,
"crushpath.com"=>9999,
"cse.tamu.edu"=>3,
"ctrip.com"=>9999,
"curtin.edu.au"=>6,
"customink.com"=>9999,
"cutler.se"=>2,
"dealhunter.se"=>9999,
"dekalexpressen.se"=>9999,
"dhl.com"=>9999,
"dito.anpdm.com"=>9999,
"dmd.idg.se"=>9999,
"dnb.se"=>5,
"dokumera.anp.se"=>9999,
"doodle.com"=>9999,
"dpj-konferens.se"=>9999,
"dpj-kontorsmobler.se"=>9999,
"drivalehmanns.se"=>9999,
"drivhuset.se"=>1,
"dropbox.com"=>9999,
"dropboxmail.com"=>9999,
"dustin.se"=>9999,
"dustinhome.se"=>9999,
"e.customink.com"=>9999,
"e.secretescapes.se"=>9999,
"e.tripadvisor.com"=>9999,
"easytranslate.se"=>9999,
"ec.europa.eu"=>4,
"eco-business.com"=>6,
"eetmail.com"=>9999,
"effectplus.se"=>5,
"ekahau.com"=>6,
"ekonaragavle.se"=>4,
"em.vistaprint.se"=>9999,
"email.alibaba.com"=>9999,
"email.br-leksaker.se"=>9999,
"email.jotex.se"=>2,
"emailing.3ds.com"=>9999,
"enews.lenovo.com"=>9999,
"enkoping.se"=>5,
"esri.com"=>6,
"esri.se"=>2,
"eu.playstationmail.net"=>9999,
"eupic.org.cn"=>6,
"europaforum.se"=>4,
"eusmecentre.org.cn"=>6,
"eventbritemail.com"=>9999,
"exeter.ac.uk"=>6,
"expressoa.com.hk"=>9999,
"factoryshopgavle.com"=>9999,
"falubo.se"=>9999,
"fanky.se"=>2,
"fastighetsbyran.se"=>9999,
"fiberdata.se"=>2,
"fiberopticvalley.com"=>5,
"fitbit.com"=>9999,
"fitnessbolaget.com"=>9999,
"flextours.se"=>9999,
"flysas.com"=>9999,
"folkspel.se"=>9999,
"foretagarforum.com"=>4,
"foretagsbladet.se"=>2,
"formgren.com"=>2,
"foursquare.com"=>9999,
"fpx.se"=>9999,
"fpxse.onmicrosoft.com"=>9999,
"franceclusters.fr"=>6,
"fyndiq.nu"=>9999,
"gadder.se"=>9999,
"gamestoresgroupsweden.se"=>9999,
"gastrikeatervinnare.se"=>4,
"gastrikevatten.se"=>4,
"gavle.se"=>4,
"gavlecentrumsamverkan.se"=>5,
"gavlefastigheter.se"=>4,
"gavlegardarna.se"=>4,
"gavlenet.se"=>9999,
"gd.se"=>2,
"gde-kontor.se"=>5,
"gdfao.gov.cn"=>6,
"gemnor.no"=>5,
"geoconnexion.com"=>5,
"geomatikk.no"=>5,
"gestrikemagasinet.se"=>2,
"getitsafe.com"=>2,
"gha.com"=>6,
"giffarna.se"=>2,
"gisprocess.com"=>2,
"glesband.nu"=>9999,
"globalexecboard.com"=>9999,
"gmail.com"=>9999,
"goodliving.nu"=>9999,
"goranssonarena.se"=>2,
"gotowebinar.com"=>9999,
"gov.se"=>4,
"gst.dk"=>6,
"gullers.se"=>2,
"guoqiang.cn"=>9999,
"gustafsbro.se"=>9999,
"haier.com"=>6,
"halsansnyaverktyg.se"=>5,
"halsingland.se"=>5,
"hammerin.se"=>2,
"hamrinr.se"=>9999,
"hariett.se"=>2,
"healthhackday.com"=>5,
"help-forward.gr"=>6,
"hig.se"=>3,
"hinttech.com"=>9999,
"hktdc.com"=>9999,
"hktdc.org"=>6,
"hktrader.hktdc.com"=>6,
"hobbex.se"=>9999,
"hogskolanigavle.onmicrosoft.com"=>3,
"hotmail.com"=>9999,
"hotmail.se"=>9999,
"Hudiksvall.se"=>4,
"hyperisland.com"=>7,
"ibas.se"=>2,
"icloud.com"=>9999,
"id2.idrelay.com"=>9999,
"idg.se"=>2,
"idgmiljoaktuellt.anp.se"=>9999,
"iebmedia.com"=>9999,
"iht.se"=>3,
"iinet.net.au"=>9999,
"iis.se"=>4,
"ikeafamily.anpdm.com"=>9999,
"incoax.com"=>2,
"infobas.se"=>2,
"inkopgavleborg.se"=>4,
"interlan.se"=>2,
"invotech.se"=>2,
"inwarehouse.se"=>9999,
"iro3.com"=>9999,
"itbaltic.com"=>2,
"itmaskinen.se"=>2,
"itmmobile.com"=>9999,
"ivl.se"=>3,
"jajjamagazine.se"=>9999,
"jamback.se"=>2,
"jarlman.se"=>2,
"jebsen.com"=>9999,
"jnabc123.com"=>9999,
"jpinfonet.se"=>2,
"jwassists.com"=>9999,
"kaffepoolen.se"=>9999,
"kalixtele24.se"=>9999,
"karmaresorts.com"=>9999,
"kfsh.se"=>4,
"ki.se"=>3,
"knewtour.com"=>9999,
"knowit.se"=>2,
"kokaihop.se"=>9999,
"komplett.se"=>9999,
"konditorilido.se"=>9999,
"koneo.se"=>9999,
"kontigo.se"=>2,
"kontorspoolen.se"=>9999,
"kristdemokraterna.se"=>4,
"kth.se"=>3,
"lania.se"=>2,
"lansstyrelsen.se"=>4,
"leapmotion.com"=>6,
"lekmer.se"=>9999,
"letsdeal.se"=>9999,
"lg.se"=>4,
"libero.se"=>9999,
"lindex.com"=>9999,
"lm.se"=>4,
"lnk.md"=>9999,
"lonnsbuss.se"=>2,
"lookbook.nu"=>9999,
"loopia.se"=>9999,
"luanett.com.br"=>9999,
"lumoback.com"=>6,
"lyreco-newsletter.se"=>9999,
"mackmyra.se"=>2,
"magnusson.nu"=>2,
"mail.hotels.com"=>9999,
"mail1.prezi.com"=>9999,
"mailer.altova.com"=>9999,
"mailer.runnersworld.se"=>9999,
"managewp.com"=>9999,
"mapandcoach.se"=>2,
"mapont.se"=>9999,
"mapuni.com"=>2,
"marriott-email.com"=>9999,
"me.com"=>9999,
"mediaevolution.se"=>5,
"meetup.com"=>9999,
"mentor.anp.se"=>9999,
"mentorab.se"=>9999,
"mentoronline.se"=>9999,
"mercell.com"=>6,
"metria.se"=>2,
"mhk.cci.se"=>5,
"mindjet.com"=>9999,
"mindspring.com"=>9999,
"mintind.com"=>6,
"mittmedia.se"=>2,
"miun.se"=>3,
"moderat.se"=>9999,
"movexum.se"=>1,
"mrgreen.com"=>9999,
"mrinfo.se"=>2,
"msb.se"=>9999,
"msn.com"=>9999,
"multinet.se"=>9999,
"mybasis.com"=>9999,
"myheritage.com"=>9999,
"mylapka.com"=>9999,
"myrtall.com"=>2,
"naturlara.se"=>7,
"news.groupon.se"=>9999,
"news.projectplace.com"=>9999,
"news.sedo.com"=>9999,
"news.spotifymail.com"=>9999,
"news.vimeo.com"=>9999,
"nextstopyou.se"=>9999,
"noaq.com"=>2,
"nordea.com"=>2,
"nordea.se"=>2,
"nosp.eclub.se"=>9999,
"notisum.se"=>9999,
"novapark.com"=>9999,
"nsecc.fi"=>5,
"nyhetsbrev.dagensps.se"=>9999,
"nyhetsbrev.matklubben.se"=>9999,
"nymangraphics.se"=>2,
"odla.nu"=>9999,
"offentligchef.com"=>9999,
"online.staples.se"=>9999,
"onlineforce.net"=>9999,
"onlinegruppen.se"=>2,
"onlinepizza.se"=>9999,
"onlinesalesdata.com"=>9999,
"opennet.se"=>2,
"orbotix.com"=>9999,
"oslomedtech.no"=>6,
"ovako.com"=>2,
"paper.li"=>9999,
"peopleinthepark.se"=>9999,
"persamuelsson.se"=>2,
"phz.ch"=>6,
"pizzaonline.se"=>9999,
"posten.se"=>9999,
"precisreklam.se"=>2,
"processim.com"=>2,
"projekt-parken.se"=>2,
"ps.nu"=>9999,
"pts.se"=>4,
"qq.com"=>9999,
"quartzspark.com"=>9999,
"rcon-sweden.se"=>2,
"realize.se"=>2,
"redikod.com"=>6,
"reflectus.se"=>2,
"regeringen.se"=>9999,
"regeringskansliet.se"=>4,
"regiongavleborg.se"=>4,
"regionvarmland.se"=>4,
"rfkl.se"=>4,
"riksbyggen.se"=>9999,
"rmp.gov.my"=>9999,
"roadroid.com"=>2,
"roda.se"=>9999,
"rtm.vistaprint.se"=>9999,
"rts.se"=>5,
"sacc-usa.org"=>6,
"safe.com"=>9999,
"salesab.se"=>9999,
"salesstuff.se"=>9999,
"sandbackapark.com"=>5,
"sandvik.com"=>2,
"sandviken.se"=>4,
"sas.se"=>9999,
"sbu.se"=>3,
"scandichotels.com"=>9999,
"scb.se"=>4,
"scorettfootwear.anp.se"=>9999,
"se.expediamail.com"=>9999,
"se.gt.com"=>2,
"seat24.com"=>9999,
"sedirekt.se"=>9999,
"seesaw.se"=>2,
"sencha.com"=>9999,
"sendgrid.com"=>9999,
"senionlab.com"=>2,
"sensorsandsystems.com"=>2,
"sensysmag.com"=>6,
"service.alibaba.com"=>9999,
"service.maildirect.se"=>9999,
"service.ushi.cn"=>9999,
"sethmoulton.com"=>9999,
"s-group.se"=>2,
"sharethis.com"=>9999,
"shmu.edu.cn"=>6,
"si.se"=>4,
"sics.se"=>3,
"sina.com"=>9999,
"sipu.se"=>7,
"sis.se"=>3,
"sitra.fi"=>6,
"sj.se"=>9999,
"skl.se"=>4,
"skogsstyrelsen.se"=>4,
"slideshare.net"=>9999,
"slidesharemail.com"=>9999,
"smartbrief.com"=>9999,
"sme4fire.eu"=>9999,
"smedjebacken.se"=>9999,
"smi.se"=>2,
"snyggmedia.se"=>2,
"spacetronic.se"=>2,
"sprend.com"=>9999,
"starrepublic.com"=>9999,
"stayfriends.se"=>9999,
"stgertrud.anp.se"=>9999,
"storabrannbo.se"=>9999,
"studieframjandet.se"=>7,
"stylusstudio.com"=>9999,
"sunydutchess.edu"=>9999,
"supportcaddy.com"=>9999,
"sustainable-sweden.se"=>5,
"sustenance.se"=>2,
"svenskfast.se"=>9999,
"svenskform.se"=>9999,
"sweco.se"=>2,
"swedalar.se"=>6,
"swedesurvey.se"=>2,
"syntronic.com"=>2,
"taltofest.se"=>9999,
"tamu.edu"=>6,
"teknikdalen.se"=>5,
"teknopol.se"=>5,
"telefonkonferens.nu"=>9999,
"telekomnyheterna.se"=>9999,
"telia.com"=>9999,
"telia.se"=>9999,
"teliasonera.com"=>9999,
"tendensor.se"=>2,
"teria.se"=>2,
"terrafirma.se"=>2,
"thecopia.com"=>9999,
"thekerryhotels.com"=>9999,
"thelmagazine.com"=>9999,
"tiandirongtong.com"=>9999,
"tillvaxtverket.se"=>4,
"topstreetwear.com"=>9999,
"trafikverket.se"=>4,
"tretti.se"=>9999,
"triona.se"=>2,
"tripit.com"=>9999,
"trogenssons.se"=>9999,
"trolskaskogen.se"=>2,
"trycktrean.nu"=>2,
"tsg.la"=>6,
"tumblr.com"=>9999,
"tvapunktett.se"=>2,
"tv-nyheterna.se"=>9999,
"twilfit.se"=>9999,
"uli.se"=>5,
"unionen.se"=>9999,
"userneeds.se"=>9999,
"utskick.idg.se"=>9999,
"vanersborg.se"=>9999,
"vgocom.com"=>9999,
"vimeo.com"=>9999,
"vinguiden.com"=>9999,
"vinnova.se"=>4,
"vip.126.com"=>9999,
"vip.163.com"=>9999,
"voddler.com"=>9999,
"wallnersbuss.se"=>2,
"wiccon.se"=>2,
"wiotech.se"=>2,
"wordpress.com"=>9999,
"wtcmumbai.org"=>9999,
"xacta.eu"=>9999,
"xerox.com"=>9999,
"xmedialab.com"=>6,
"yahoo.cn"=>9999,
"yahoo.com"=>9999,
"yahoo.com.hk"=>9999,
"zamzar.com"=>9999,
"zju.edu.cn"=>6,
"ztea.org"=>6,
"4sound.se"=>9999,
"academicum.se"=>7,
"atvhuset.se"=>9999,
"bcm.co.th"=>9999,
"caperga.se"=>9999,
"dlh.de"=>6,
"email.ft.com"=>9999,
"foretagstv.com"=>9999,
"hp.com"=>9999,
"innosport.nl"=>6,
"kuntin.com"=>6,
"lfl.se"=>9999,
"lists.ce.org"=>9999,
"magnolia-ba.biz"=>9999,
"n-euroclinix.net"=>9999,
"news.wanwang.com"=>9999,
"novogit.se"=>2,
"ohappa.se"=>9999,
"science-link.eu"=>6,
"sdr.org"=>9999,
"soderpalm.se"=>9999,
"superpedestrian.com"=>9999,
"sverok.se"=>7,
"ticnet.se"=>9999,
"vfemail.net"=>9999,
"yammer-email.com"=>9999,
"haystack.se"=>9999,
"mail.alipay.com"=>9999,
"mail.chinadailyuk.com"=>9999,
"mail.myxperia.sonymobile.com"=>9999,
"mail.quicksearch.se"=>9999,
"mail.wingateservices.com"=>9999,
"mail0.atl31.mcdlv.net"=>9999,
"mail1.atl91.mcsv.net"=>9999,
"mail1.kokaihop.se"=>9999,
"mail1.mcsignup.com"=>9999,
"mail1.tinyletterapp.com"=>9999,
"mail1.wdc03.rsgsv.net"=>9999,
"mail10.atl91.mcsv.net"=>9999,
"mail10.surf-town.net"=>9999,
"mail10.wdc01.mcdlv.net"=>9999,
"mail11.atl91.mcsv.net"=>9999,
"mail11.wdc01.mcdlv.net"=>9999,
"mail12.wdc01.mcdlv.net"=>9999,
"mail128.atl61.mcsv.net"=>9999,
"mail128-136.atl41.mandrillapp.com"=>9999,
"mail128-19.atl41.mandrillapp.com"=>9999,
"mail13.atl11.rsgsv.net"=>9999,
"mail13.atl91.mcsv.net"=>9999,
"mail130.atl81.rsgsv.net"=>9999,
"mail131.atl101.mcdlv.net"=>9999,
"mail131.atl121.mcsv.net"=>9999,
"mail132.atl101.mcdlv.net"=>9999,
"mail132-5.atl131.mandrillapp.com"=>9999,
"mail133.atl101.mcdlv.net"=>9999,
"mail133.atl121.mcsv.net"=>9999,
"mail134.atl61.mcsv.net"=>9999,
"mail134.wdc02.mcdlv.net"=>9999,
"mail137.atl121.mcsv.net"=>9999,
"mail138.wdc02.mcdlv.net"=>9999,
"mail14.atl161.mcsv.net"=>9999,
"mail14.atl51.rsgsv.net"=>9999,
"mail14.wdc01.mcdlv.net"=>9999,
"mail141.atl101.mcdlv.net"=>9999,
"mail141.wdc01.mcdlv.net"=>9999,
"mail141.wdc02.mcdlv.net"=>9999,
"mail142.atl101.mcdlv.net"=>9999,
"mail142.atl121.mcsv.net"=>9999,
"mail142.wdc02.mcdlv.net"=>9999,
"mail143.atl101.mcdlv.net"=>9999,
"mail143.atl61.mcsv.net"=>9999,
"mail143.us4.mcsv.net"=>9999,
"mail146.atl81.rsgsv.net"=>9999,
"mail147.atl121.mcsv.net"=>9999,
"mail149.atl81.rsgsv.net"=>9999,
"mail150.atl101.mcdlv.net"=>9999,
"mail151.atl101.mcdlv.net"=>9999,
"mail151.wdc02.mcdlv.net"=>9999,
"mail152.atl101.mcdlv.net"=>9999,
"mail152.atl61.mcsv.net"=>9999,
"mail152.us4.mcsv.net"=>9999,
"mail153.atl121.mcsv.net"=>9999,
"mail153.wdc02.mcdlv.net"=>9999,
"mail155.atl121.mcsv.net"=>9999,
"mail155.atl81.rsgsv.net"=>9999,
"mail157.atl121.mcsv.net"=>9999,
"mail158.atl21.rsgsv.net"=>9999,
"mail158.atl61.mcsv.net"=>9999,
"mail159.atl81.rsgsv.net"=>9999,
"mail16.wdc01.mcdlv.net"=>9999,
"mail160.atl121.mcsv.net"=>9999,
"mail160.atl61.mcsv.net"=>9999,
"mail161.wdc02.mcdlv.net"=>9999,
"mail163.atl21.rsgsv.net"=>9999,
"mail163.atl81.rsgsv.net"=>9999,
"mail164.atl101.mcdlv.net"=>9999,
"mail164.atl21.rsgsv.net"=>9999,
"mail165.atl121.mcsv.net"=>9999,
"mail165.atl61.mcsv.net"=>9999,
"mail165.atl81.rsgsv.net"=>9999,
"mail166.atl61.mcsv.net"=>9999,
"mail166.atl81.rsgsv.net"=>9999,
"mail167.atl61.mcsv.net"=>9999,
"mail168.atl101.mcdlv.net"=>9999,
"mail168.atl61.mcsv.net"=>9999,
"mail168.atl81.rsgsv.net"=>9999,
"mail169.atl21.rsgsv.net"=>9999,
"mail17.wdc01.mcdlv.net"=>9999,
"mail170.atl101.mcdlv.net"=>9999,
"mail170.atl121.mcsv.net"=>9999,
"mail170.atl61.mcsv.net"=>9999,
"mail170.wdc02.mcdlv.net"=>9999,
"mail171.atl121.mcsv.net"=>9999,
"mail171.atl21.rsgsv.net"=>9999,
"mail172.atl61.mcsv.net"=>9999,
"mail173.atl101.mcdlv.net"=>9999,
"mail173.atl121.mcsv.net"=>9999,
"mail173.atl61.mcsv.net"=>9999,
"mail174.atl101.mcdlv.net"=>9999,
"mail174.atl21.rsgsv.net"=>9999,
"mail175.atl101.mcdlv.net"=>9999,
"mail175.us4.mcsv.net"=>9999,
"mail176.wdc02.mcdlv.net"=>9999,
"mail177.atl121.mcsv.net"=>9999,
"mail177.atl61.mcsv.net"=>9999,
"mail177.wdc02.mcdlv.net"=>9999,
"mail178.atl101.mcdlv.net"=>9999,
"mail178.atl121.mcsv.net"=>9999,
"mail18.atl161.mcsv.net"=>9999,
"mail18.wdc01.mcdlv.net"=>9999,
"mail180.atl101.mcdlv.net"=>9999,
"mail180.atl121.mcsv.net"=>9999,
"mail181.atl81.rsgsv.net"=>9999,
"mail181.wdc02.mcdlv.net"=>9999,
"mail182.atl121.mcsv.net"=>9999,
"mail182.atl61.mcsv.net"=>9999,
"mail182.wdc02.mcdlv.net"=>9999,
"mail183.atl101.mcdlv.net"=>9999,
"mail183.wdc02.mcdlv.net"=>9999,
"mail184.atl121.mcsv.net"=>9999,
"mail185.wdc02.mcdlv.net"=>9999,
"mail186.atl101.mcdlv.net"=>9999,
"mail186.atl21.rsgsv.net"=>9999,
"mail186.wdc02.mcdlv.net"=>9999,
"mail187.atl21.rsgsv.net"=>9999,
"mail187.wdc02.mcdlv.net"=>9999,
"mail188.wdc02.mcdlv.net"=>9999,
"mail19.us4.mcsv.net"=>9999,
"mail190.atl61.mcsv.net"=>9999,
"mail191.atl101.mcdlv.net"=>9999,
"mail191.atl121.mcsv.net"=>9999,
"mail191.atl21.rsgsv.net"=>9999,
"mail192.atl101.mcdlv.net"=>9999,
"mail192.wdc02.mcdlv.net"=>9999,
"mail194.atl61.mcsv.net"=>9999,
"mail195.atl121.mcsv.net"=>9999,
"mail195.atl21.rsgsv.net"=>9999,
"mail196.atl101.mcdlv.net"=>9999,
"mail198.atl121.mcsv.net"=>9999,
"mail2.atl161.mcsv.net"=>9999,
"mail2.wdc04.mandrillapp.com"=>9999,
"mail20.atl161.mcsv.net"=>9999,
"mail20.atl91.mcsv.net"=>9999,
"mail20.us4.mcsv.net"=>9999,
"mail20.wdc03.rsgsv.net"=>9999,
"mail200.atl101.mcdlv.net"=>9999,
"mail201.atl21.rsgsv.net"=>9999,
"mail201.atl81.rsgsv.net"=>9999,
"mail204.atl81.rsgsv.net"=>9999,
"mail206.atl81.rsgsv.net"=>9999,
"mail207.atl61.mcsv.net"=>9999,
"mail208.atl21.rsgsv.net"=>9999,
"mail21.atl91.mcsv.net"=>9999,
"mail22.atl161.mcsv.net"=>9999,
"mail22.wdc03.rsgsv.net"=>9999,
"mail221.atl101.mcdlv.net"=>9999,
"mail221.atl121.mcsv.net"=>9999,
"mail222.atl121.mcsv.net"=>9999,
"mail223.atl21.rsgsv.net"=>9999,
"mail225.atl21.rsgsv.net"=>9999,
"mail227.atl121.mcsv.net"=>9999,
"mail228.atl121.mcsv.net"=>9999,
"mail24.wdc03.rsgsv.net"=>9999,
"mail25.wdc03.rsgsv.net"=>9999,
"mail27.atl31.mcdlv.net"=>9999,
"mail27.wdc03.rsgsv.net"=>9999,
"mail28.atl91.mcsv.net"=>9999,
"mail289.us2.mcsv.net"=>9999,
"mail29.atl51.rsgsv.net"=>9999,
"mail29.us4.mcsv.net"=>9999,
"mail3.atl71.mcdlv.net"=>9999,
"mail3.atl91.mcsv.net"=>9999,
"mail30.atl91.mcsv.net"=>9999,
"mail300.us2.mcsv.net"=>9999,
"mail31.atl161.mcsv.net"=>9999,
"mail31.atl71.mcdlv.net"=>9999,
"mail31.wdc01.mcdlv.net"=>9999,
"mail316.us2.mcsv.net"=>9999,
"mail32.atl11.rsgsv.net"=>9999,
"mail320.us2.mcsv.net"=>9999,
"mail323.us2.mcsv.net"=>9999,
"mail328.us2.mcsv.net"=>9999,
"mail33.wdc01.mcdlv.net"=>9999,
"mail331.us2.mcsv.net"=>9999,
"mail34.atl161.mcsv.net"=>9999,
"mail34.atl31.mcdlv.net"=>9999,
"mail34.wdc03.rsgsv.net"=>9999,
"mail340.us2.mcsv.net"=>9999,
"mail35.atl51.rsgsv.net"=>9999,
"mail35.atl71.mcdlv.net"=>9999,
"mail35.wdc03.rsgsv.net"=>9999,
"mail352.us3.mcdlv.net"=>9999,
"mail357.us2.mcsv.net"=>9999,
"mail36.atl51.rsgsv.net"=>9999,
"mail36.atl71.mcdlv.net"=>9999,
"mail36.atl91.mcsv.net"=>9999,
"mail36.wdc01.mcdlv.net"=>9999,
"mail363.us2.mcsv.net"=>9999,
"mail37.atl11.rsgsv.net"=>9999,
"mail37.atl91.mcsv.net"=>9999,
"mail37.wdc01.mcdlv.net"=>9999,
"mail39.atl11.rsgsv.net"=>9999,
"mail39.atl31.mcdlv.net"=>9999,
"mail39.atl91.mcsv.net"=>9999,
"mail4.atl91.mcsv.net"=>9999,
"mail4.mcsignup.com"=>9999,
"mail40.atl51.rsgsv.net"=>9999,
"mail40.atl71.mcdlv.net"=>9999,
"mail40.atl91.mcsv.net"=>9999,
"mail40.us4.mcsv.net"=>9999,
"mail41.atl11.rsgsv.net"=>9999,
"mail41.atl91.mcsv.net"=>9999,
"mail42.atl71.mcdlv.net"=>9999,
"mail42.atl91.mcsv.net"=>9999,
"mail42.us4.mcsv.net"=>9999,
"mail42.wdc01.mcdlv.net"=>9999,
"mail43.atl31.mcdlv.net"=>9999,
"mail43.atl51.rsgsv.net"=>9999,
"mail43.us4.mcsv.net"=>9999,
"mail44.atl31.mcdlv.net"=>9999,
"mail44.atl91.mcsv.net"=>9999,
"mail45.atl111.rsgsv.net"=>9999,
"mail45.atl31.mcdlv.net"=>9999,
"mail45.atl51.rsgsv.net"=>9999,
"mail45.atl71.mcdlv.net"=>9999,
"mail45.wdc03.rsgsv.net"=>9999,
"mail47.atl91.mcsv.net"=>9999,
"mail47.wdc03.rsgsv.net"=>9999,
"mail48.wdc01.mcdlv.net"=>9999,
"mail49.atl11.rsgsv.net"=>9999,
"mail49.atl31.mcdlv.net"=>9999,
"mail49.atl71.mcdlv.net"=>9999,
"mail49.atl91.mcsv.net"=>9999,
"mail50.atl31.mcdlv.net"=>9999,
"mail51.atl161.mcsv.net"=>9999,
"mail51.atl51.rsgsv.net"=>9999,
"mail52.atl91.mcsv.net"=>9999,
"mail53.atl71.mcdlv.net"=>9999,
"mail53.atl91.mcsv.net"=>9999,
"mail54.wdc01.mcdlv.net"=>9999,
"mail56.atl31.mcdlv.net"=>9999,
"mail57.wdc03.rsgsv.net"=>9999,
"mail58.atl51.rsgsv.net"=>9999,
"mail58.wdc01.mcdlv.net"=>9999,
"mail59.atl71.mcdlv.net"=>9999,
"mail59.atl91.mcsv.net"=>9999,
"mail6.atl31.mcdlv.net"=>9999,
"mail6.atl71.mcdlv.net"=>9999,
"mail6.atl91.mcsv.net"=>9999,
"mail61.atl91.mcsv.net"=>9999,
"mail62.atl111.rsgsv.net"=>9999,
"mail62.atl71.mcdlv.net"=>9999,
"mail63.atl31.mcdlv.net"=>9999,
"mail64.atl11.rsgsv.net"=>9999,
"mail64.atl161.mcsv.net"=>9999,
"mail64.atl71.mcdlv.net"=>9999,
"mail64.atl91.mcsv.net"=>9999,
"mail65.atl71.mcdlv.net"=>9999,
"mail65.wdc01.mcdlv.net"=>9999,
"mail66.atl11.rsgsv.net"=>9999,
"mail66.atl91.mcsv.net"=>9999,
"mail66.us4.mcsv.net"=>9999,
"mail67.atl11.rsgsv.net"=>9999,
"mail67.atl91.mcsv.net"=>9999,
"mail68.atl91.mcsv.net"=>9999,
"mail68.wdc01.mcdlv.net"=>9999,
"mail68.wdc03.rsgsv.net"=>9999,
"mail69.atl71.mcdlv.net"=>9999,
"mail69.atl91.mcsv.net"=>9999,
"mail7.atl31.mcdlv.net"=>9999,
"mail7.atl71.mcdlv.net"=>9999,
"mail70.atl51.rsgsv.net"=>9999,
"mail71.atl31.mcdlv.net"=>9999,
"mail71.us4.mcsv.net"=>9999,
"mail71.wdc01.mcdlv.net"=>9999,
"mail72.atl31.mcdlv.net"=>9999,
"mail73.atl31.mcdlv.net"=>9999,
"mail74.atl51.rsgsv.net"=>9999,
"mail75.us4.mcsv.net"=>9999,
"mail76.us2.rsgsv.net"=>9999,
"mail77.atl31.mcdlv.net"=>9999,
"mail78.us4.mcsv.net"=>9999,
"mail8.atl11.rsgsv.net"=>9999,
"mail8.atl91.mcsv.net"=>9999,
"mail8.rap.tns-online.com"=>9999,
"mail82.atl91.mcsv.net"=>9999,
"mail83.atl51.rsgsv.net"=>9999,
"mail83.us2.rsgsv.net"=>9999,
"mail84.atl91.mcsv.net"=>9999,
"mail86.atl111.rsgsv.net"=>9999,
"mail87.us4.mcsv.net"=>9999,
"mail88.atl31.mcdlv.net"=>9999,
"mail89.atl11.rsgsv.net"=>9999,
"mail89.us4.mcsv.net"=>9999,
"mail9.atl31.mcdlv.net"=>9999,
"mail91.atl161.mcsv.net"=>9999,
"mail92.atl111.rsgsv.net"=>9999,
"mail94.atl91.mcsv.net"=>9999,
"mail95.atl91.mcsv.net"=>9999,
"mail97.atl91.mcsv.net"=>9999,
"mail97.us4.mcsv.net"=>9999,
"mail98.atl111.rsgsv.net"=>9999,
"mail99.atl111.rsgsv.net"=>9999,
"mail99.atl91.mcsv.net"=>9999,
"mailer.netflix.com"=>9999,
"mailer.womenshealth.se"=>9999,
"mailgun.org"=>9999,
"mailgw3.vinnova.se"=>9999,
"mailings.adamello.se"=>9999,
"mailings.elite-kontorsstolar.se"=>9999,
"mailon.se"=>9999,
"mail-server24.com"=>9999,
"mail-server24.org"=>9999,
"mailsupporten.se"=>9999,
"mailtao.com"=>9999,
"account.microsoft.com"=>9999,
"accounts.google.com"=>9999,
"adobe.com"=>9999,
"adobe-emea.com"=>9999,
"antispam2.lst.se"=>9999,
"em.harrahs-notifications.com"=>9999,
"email.aldebaran.com"=>9999,
"email.americanexpress.com"=>9999,
"email.ba.com"=>9999,
"email.carlsonhotels.com"=>9999,
"email.finnair.com"=>9999,
"email.microsoftonline.com"=>9999,
"email.newsletters.finnair.com"=>9999,
"email.servicemailnordic.com"=>9999,
"email.sg.rentalcars.com"=>9999,
"email.ticnet.se"=>9999,
"emailcounts.com"=>9999,
"emailing.cafe-frappe.fr"=>9999,
"email-langhamhotels.com"=>9999,
"emails.skype.com"=>9999,
"emarketeer.com"=>9999,
"emirates.com"=>9999,
"e.paypal.se"=>9999,
"e.victoriassecret.com"=>9999,
"linkedin.com"=>9999,
"actiondialog.se"=>9999,
"agility.com"=>9999,
"art4m.se"=>9999,
"azuredragontravel.com"=>9999,
"bounce.linkedin.com"=>9999,
"bounce.meint.se"=>9999,
"britishairways.com"=>9999,
"cmail1.com"=>9999,
"cmail2.com"=>9999,
"cmail3.com"=>9999,
"createsend1.com"=>9999,
"createsend4.com"=>9999,
"di.se"=>9999,
"e.linkedin.com"=>9999,
"f-bolaget.se"=>9999,
"findit-solutions.com"=>9999,
"findit-solutions.se"=>9999,
"hardrockhotelsd.com"=>9999,
"hotmail.co.uk"=>9999,
"live.cn"=>9999,
"marketingland.com"=>9999,
"microsoft.com"=>9999,
"nospse.emea.microsoftonline.com"=>9999,
"notifications.skype.com"=>9999,
"paypal.se"=>9999,
"plus.google.com"=>9999,
"rawfoodmiddagar.com"=>9999,
"rawfoodmiddagar.se"=>9999,
"systemalerts3.mailchimp.com"=>9999,
"systemalerts4.mailchimp.com"=>9999,
"twitter.com"=>9999,
"united.com"=>9999,
"webserviceindex.se"=>9999,
"yahoo.se"=>9999,
"youtube.com"=>9999,
"academicinternshipcouncil.org"=>9999,
"ajprodukter.se"=>9999,
"akademssr.se"=>2,
"alltomjuridik.se"=>9999,
"almedalsbaten.se"=>9999,
"anp.se"=>9999,
"apolarchina.com"=>9999,
"apricon.se"=>2,
"areax.se"=>2,
"atomerochbitar.se"=>2,
"attituderec.com"=>9999,
"avisera.se"=>9999,
"avrexpos.com"=>6,
"bergakra.se"=>2,
"birgittapiippola.se"=>2,
"brandsforfans.se"=>2,
"bristol.ac.uk"=>6,
"ca-cib.com"=>6,
"cantab.nu"=>2,
"canterbury.ac.nz"=>6,
"capitala.se"=>9999,
"ccavenue.com"=>6,
"cegeoic2015.net"=>9999,
"chinadaily.com.cn"=>6,
"chinaittc.org"=>6,
"chinavpshosting.com"=>6,
"cibesliftgroup.com"=>2,
"connecteastafrica.com"=>6,
"corp.elong.com"=>6,
"crm-langhamhotels.com"=>6,
"digitalcenter.org"=>6,
"digitalmarketingdepot.com"=>6,
"dios.se"=>2,
"dream-spo.com"=>6,
"e.globearenas.se"=>2,
"e3pl.se"=>2,
"easytryck.se"=>2,
"echallenges.org"=>6,
"eecw.com.au"=>6,
"ellensskafferi.se"=>2,
"Elvelid"=>9999,
"engelska.se"=>7,
"eskilstuna.se"=>4,
"estimote.com"=>6,
"fenrir.se"=>2,
"finnair.com"=>6,
"fittogether.se"=>2,
"folkuniversitetet.se"=>7,
"foretagsringen.se"=>5,
"foxmail.com"=>6,
"freemanco.com"=>6,
"gastidr.se"=>2,
"geoforum.no"=>6,
"geog.ucsb.edu"=>6,
"geomaticsnorway.no"=>6,
"geospatialmedia.net"=>5,
"getpocket.com"=>9999,
"ghd.com"=>6,
"gleammusic.com"=>9999,
"gmmm.se"=>2,
"greencity.iro3.com"=>9999,
"health.wa.gov.au"=>6,
"hedlunds-vvs.se"=>2,
"hexagongeospatial.com"=>2,
"hotels.com"=>6,
"hsiinfo.se"=>2,
"hutb.se"=>7,
"hxgnlive.com"=>2,
"i2i.se"=>2,
"imgartists.com"=>6,
"ingstad.se"=>2,
"Inlandsinnovation.se"=>4,
"inno-creativeab.com"=>2,
"innovativecity.iro3.com"=>9999,
"InsideApple.Apple.com"=>9999,
"interflora.se"=>2,
"interpool.se"=>2,
"iqs.se"=>2,
"it-services.me"=>9999,
"joyoaudio.com"=>6,
"juicymaps.com"=>2,
"julong.com.cn"=>6,
"klog.se"=>9999,
"kommunikation.sj.se"=>9999,
"KONFE"=>9999,
"krigsmyter.nu"=>9999,
"kvadrat.se"=>2,
"landgate.wa.gov.au"=>6,
"landraddningen.se"=>2,
"lansforsakringar.com"=>2,
"lansforsakringar.se"=>2,
"leadscloud.net"=>9999,
"leadsforseeds.com"=>6,
"lehmannskok.se"=>9999,
"lexicon.se"=>2,
"liu.se"=>7,
"live.se"=>9999,
"logiwaste.se"=>2,
"lyyti.fi"=>6,
"market-ro.eu"=>9999,
"max.se"=>9999,
"mcgloballoyaltyclub.com"=>6,
"miljorapporten.se"=>2,
"mindfulbusiness.nu"=>2,
"mitt-barn.se"=>2,
"mlnewsletterse.com"=>9999,
"mm.loc"=>9999,
"mms.telia.com"=>9999,
"mms-email.telenor.se"=>9999,
"montellpartners.se"=>6,
"msiprod.com"=>6,
"musitag.com"=>9999,
"myairbridge.com"=>9999,
"nci-ab.com"=>9999,
"nervelabs.se"=>2,
"new.itunes.com"=>9999,
"newplace.se"=>2,
"normannpartners.com"=>6,
"norrlandsfonden.se"=>1,
"nyhetsbrev.dagensvd.se"=>9999,
"nyteknik.se"=>2,
"oculus.com"=>6,
"oculusvr.com"=>6,
"one.com"=>9999,
"onlineupdate.com"=>9999,
"orbiz.com.br"=>9999,
"parker-software.com"=>6,
"planbab.com"=>2,
"plma.se"=>9999,
"pne.skanova.net"=>2,
"ponchospecialist.eu"=>9999,
"position2015.se"=>2,
"prepedyouth.se"=>2,
"proandpro.se"=>2,
"processum.se"=>9999,
"procurator.se"=>2,
"projects.se"=>2,
"prylstaden.se"=>9999,
"r.grouponmail.se"=>9999,
"rdabrisbane.org.au"=>2,
"regus.com"=>6,
"reply.thirddoormedia.com"=>9999,
"Resekompani.se"=>2,
"restaurangteknikparken.se"=>2,
"robotdalen.se"=>5,
"sacc-usa.ccsend.com"=>9999,
"sandbergmail.com"=>9999,
"sc-ab.com"=>2,
"searchengineland.com"=>9999,
"searchmarketingexpo.com"=>9999,
"secure.se"=>2,
"service.govdelivery.com"=>9999,
"service.zalando.se"=>9999,
"sg.booking.com"=>9999,
"sgroup-solutions.se"=>2,
"singaporeair.com.sg"=>6,
"skatteverket.se"=>4,
"smartdata.iro3.com"=>9999,
"socialforum.se"=>2,
"sodexo.com"=>6,
"stalquist.se"=>2,
"standardbolag.se"=>2,
"steadson.com"=>2,
"student.su.se"=>7,
"studiolisabengtsson.se"=>2,
"sundaramappliedtechnologies.com"=>6,
"supportia.se"=>9999,
"svartpist.com"=>2,
"svepost.se"=>9999,
"swecogroup.com"=>2,
"swedenict.com"=>5,
"swedishchamber.com.cn"=>4,
"techsoup.se"=>2,
"teknikparken.se"=>4,
"temagon.se"=>2,
"tematik.se"=>2,
"theeyetribe.com"=>6,
"thomassandberg.se"=>2,
"toimprove.se"=>2,
"transpacificip.com"=>6,
"travelfinder.se"=>9999,
"tru.ca"=>6,
"trycktrean.se"=>2,
"tuke.sk"=>6,
"uadm.uu.se"=>7,
"ubifrance.fr"=>6,
"utskick.personalrabatten.se"=>9999,
"utskick.sportadmin.se"=>9999,
"vansterpartiet.se"=>4,
"vaultpress.com"=>6,
"vikingline.com"=>2,
"viktoria.se"=>2,
"ving.se"=>2,
"wheresmysuitcase.com"=>6,
"whu.edu.cn"=>6,
"wish.com"=>6,
"yugongyishan.com"=>6}


end
