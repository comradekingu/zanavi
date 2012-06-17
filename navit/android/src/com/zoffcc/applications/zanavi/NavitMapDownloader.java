/**
 * ZANavi, Zoff Android Navigation system.
 * Copyright (C) 2011-2012 Zoff <zoff@zoff.cc>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA  02110-1301, USA.
 */

/**
 * Navit, a modular navigation system.
 * Copyright (C) 2005-2008 Navit Team
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA  02110-1301, USA.
 */

package com.zoffcc.applications.zanavi;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.RandomAccessFile;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.X509TrustManager;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

public class NavitMapDownloader
{
	static final String ZANAVI_MAPS_AGE_URL = "http://maps.zanavi.cc/maps_age.html";
	static final String ZANAVI_MAPS_BASE_URL = "http://dl.zanavi.cc/data/";
	static final String ZANAVI_MAPS_SEVERTEXT_URL = "http://dl.zanavi.cc/server.txt";
	static final String ZANAVI_MAPS_BASE_URL_PROTO = "http://";
	static final String ZANAVI_MAPS_BASE_URL_WO_SERVERNAME = "/data/";
	//static final String ZANAVI_MAPS_BASE_URL = "https://192.168.0.3:446/maps/";
	//static final String ZANAVI_MAPS_SEVERTEXT_URL = "https://192.168.0.3:446/maps/server.txt";
	//static final String ZANAVI_MAPS_BASE_URL_PROTO = "https://";
	//static final String ZANAVI_MAPS_BASE_URL_WO_SERVERNAME = "/maps/";

	static int MULTI_NUM_THREADS = 1; // how many download streams for a file
	static int MULTI_NUM_THREADS_LOCAL = 1; // how many download streams for the current file from the current server

	public static class zanavi_osm_map_values
	{
		String map_name = "";
		String url = "";
		long est_size_bytes = 0;
		String est_size_bytes_human_string = "";
		String text_for_select_list = "";
		Boolean is_continent = false;
		int continent_id = 0;

		public zanavi_osm_map_values(String mapname, String url, long bytes_est, Boolean is_con, int con_id)
		{
			this.is_continent = is_con;
			this.continent_id = con_id;
			this.map_name = mapname;
			this.url = url;
			this.est_size_bytes = bytes_est;
			if (this.est_size_bytes <= 0)
			{
				// dummy entry, dont show size!
				this.est_size_bytes_human_string = "";
			}
			else
			{
				if (((int) ((float) (this.est_size_bytes) / 1024f / 1024f)) > 0)
				{
					this.est_size_bytes_human_string = " " + (int) ((float) (this.est_size_bytes) / 1024f / 1024f) + "MB";
				}
				else
				{
					this.est_size_bytes_human_string = " " + (int) ((float) (this.est_size_bytes) / 1024f) + "kB";
				}
			}
			this.text_for_select_list = this.map_name + " " + this.est_size_bytes_human_string;
		}
	}

	//
	// define the maps here
	//
	//
	static final zanavi_osm_map_values z_Caribbean = new zanavi_osm_map_values("Caribbean", "caribbean.bin", -2, true, 136);
	//
	static final zanavi_osm_map_values z_North_America = new zanavi_osm_map_values("North America", "north_america.bin", -2, true, 6);
	static final zanavi_osm_map_values z_Country_borders = new zanavi_osm_map_values("Country borders [detail]", "borders.bin", 6271108L, true, 0);
	static final zanavi_osm_map_values z_Coastline = new zanavi_osm_map_values("Coastline", "coastline.bin", 202836110L, true, 0);
	static final zanavi_osm_map_values z_Restl_welt = new zanavi_osm_map_values("Rest of the World", "restl_welt.bin", 128693232L, true, 0);
	static zanavi_osm_map_values z_Planet = new zanavi_osm_map_values("Planet", "planet.bin", 7257701554L, true, 1);
	static zanavi_osm_map_values z_Europe = new zanavi_osm_map_values("Europe", "europe.bin", 3812430242L, true, 3);
	static final zanavi_osm_map_values z_Africa = new zanavi_osm_map_values("Africa", "africa.bin", 144067447L, true, 4);
	static final zanavi_osm_map_values z_Asia = new zanavi_osm_map_values("Asia", "asia.bin", 791894440L, true, 5);
	static zanavi_osm_map_values z_USA = new zanavi_osm_map_values("USA", "usa.bin", 1913676437L, true, 27);
	static final zanavi_osm_map_values z_Central_America = new zanavi_osm_map_values("Central America", "central_america.bin", 82087567L, true, 7);
	static final zanavi_osm_map_values z_South_America = new zanavi_osm_map_values("South America", "south_america.bin", 155856431L, true, 8);
	static final zanavi_osm_map_values z_Australia_and_Oceania = new zanavi_osm_map_values("Australia and Oceania", "australia_oceania.bin", 116587684L, true, 9);
	static final zanavi_osm_map_values z_Albania = new zanavi_osm_map_values("Albania", "albania.bin", 2743112L, false, 3);
	static final zanavi_osm_map_values z_Alps = new zanavi_osm_map_values("Alps", "alps.bin", 484242183L, false, 3);
	static final zanavi_osm_map_values z_Andorra = new zanavi_osm_map_values("Andorra", "andorra.bin", 215301L, false, 3);
	static final zanavi_osm_map_values z_Austria = new zanavi_osm_map_values("Austria", "austria.bin", 104153554L, false, 3);
	static final zanavi_osm_map_values z_Azores = new zanavi_osm_map_values("Azores", "azores.bin", 561818L, false, 3);
	static final zanavi_osm_map_values z_Belarus = new zanavi_osm_map_values("Belarus", "belarus.bin", 27494671L, false, 3);
	static final zanavi_osm_map_values z_Belgium = new zanavi_osm_map_values("Belgium", "belgium.bin", 55288004L, false, 3);
	static final zanavi_osm_map_values z_Bosnia_Herzegovina = new zanavi_osm_map_values("Bosnia-Herzegovina", "bosnia-herzegovina.bin", 6382766L, false, 3);
	static final zanavi_osm_map_values z_British_Isles = new zanavi_osm_map_values("British Isles", "british_isles.bin", 249766346L, false, 3);
	static final zanavi_osm_map_values z_Bulgaria = new zanavi_osm_map_values("Bulgaria", "bulgaria.bin", 10915862L, false, 3);
	static final zanavi_osm_map_values z_Croatia = new zanavi_osm_map_values("Croatia", "croatia.bin", 18399655L, false, 3);
	static final zanavi_osm_map_values z_Cyprus = new zanavi_osm_map_values("Cyprus", "cyprus.bin", 3246334L, false, 3);
	static final zanavi_osm_map_values z_Czech_Republic = new zanavi_osm_map_values("Czech Republic", "czech_republic.bin", 149919268L, false, 3);
	static final zanavi_osm_map_values z_Denmark = new zanavi_osm_map_values("Denmark", "denmark.bin", 72644642L, false, 3);
	static final zanavi_osm_map_values z_Estonia = new zanavi_osm_map_values("Estonia", "estonia.bin", 15672674L, false, 3);
	static final zanavi_osm_map_values z_Faroe_Islands = new zanavi_osm_map_values("Faroe Islands", "faroe_islands.bin", 745423L, false, 3);
	static final zanavi_osm_map_values z_Finland = new zanavi_osm_map_values("Finland", "finland.bin", 74152027L, false, 3);
	static final zanavi_osm_map_values z_France = new zanavi_osm_map_values("France", "france.bin", 1139293586L, false, 3);
	static final zanavi_osm_map_values z_Germany = new zanavi_osm_map_values("Germany", "germany.bin", 622438494L, false, 3);
	static final zanavi_osm_map_values z_Great_Britain = new zanavi_osm_map_values("Great Britain", "great_britain.bin", 226752913L, false, 3);
	static final zanavi_osm_map_values z_Greece = new zanavi_osm_map_values("Greece", "greece.bin", 33662627L, false, 3);
	static final zanavi_osm_map_values z_Hungary = new zanavi_osm_map_values("Hungary", "hungary.bin", 16618127L, false, 3);
	static final zanavi_osm_map_values z_Iceland = new zanavi_osm_map_values("Iceland", "iceland.bin", 4927694L, false, 3);
	static final zanavi_osm_map_values z_Ireland = new zanavi_osm_map_values("Ireland", "ireland.bin", 20402776L, false, 3);
	static final zanavi_osm_map_values z_Isle_of_man = new zanavi_osm_map_values("Isle of man", "isle_of_man.bin", 926380L, false, 3);
	static final zanavi_osm_map_values z_Italy = new zanavi_osm_map_values("Italy", "italy.bin", 246690915L, false, 3);
	static final zanavi_osm_map_values z_Kosovo = new zanavi_osm_map_values("Kosovo", "kosovo.bin", 5279208L, false, 3);
	static final zanavi_osm_map_values z_Latvia = new zanavi_osm_map_values("Latvia", "latvia.bin", 15247896L, false, 3);
	static final zanavi_osm_map_values z_Liechtenstein = new zanavi_osm_map_values("Liechtenstein", "liechtenstein.bin", 289127L, false, 3);
	static final zanavi_osm_map_values z_Lithuania = new zanavi_osm_map_values("Lithuania", "lithuania.bin", 11211874L, false, 3);
	static final zanavi_osm_map_values z_Luxembourg = new zanavi_osm_map_values("Luxembourg", "luxembourg.bin", 5526557L, false, 3);
	static final zanavi_osm_map_values z_Macedonia = new zanavi_osm_map_values("Macedonia", "macedonia.bin", 2483694L, false, 3);
	static final zanavi_osm_map_values z_Malta = new zanavi_osm_map_values("Malta", "malta.bin", 706285L, false, 3);
	static final zanavi_osm_map_values z_Moldova = new zanavi_osm_map_values("Moldova", "moldova.bin", 6956958L, false, 3);
	static final zanavi_osm_map_values z_Monaco = new zanavi_osm_map_values("Monaco", "monaco.bin", 86325L, false, 3);
	static final zanavi_osm_map_values z_Montenegro = new zanavi_osm_map_values("Montenegro", "montenegro.bin", 1264304L, false, 3);
	static final zanavi_osm_map_values z_Netherlands = new zanavi_osm_map_values("Netherlands", "netherlands.bin", 217437801L, false, 3);
	static final zanavi_osm_map_values z_Norway = new zanavi_osm_map_values("Norway", "norway.bin", 42651542L, false, 3);
	static final zanavi_osm_map_values z_Poland = new zanavi_osm_map_values("Poland", "poland.bin", 90243619L, false, 3);
	static final zanavi_osm_map_values z_Portugal = new zanavi_osm_map_values("Portugal", "portugal.bin", 29058988L, false, 3);
	static final zanavi_osm_map_values z_Romania = new zanavi_osm_map_values("Romania", "romania.bin", 33265442L, false, 3);
	static final zanavi_osm_map_values z_Russia_European_part = new zanavi_osm_map_values("Russia European part", "russia-european-part.bin", 182888939L, false, 3);
	static final zanavi_osm_map_values z_Serbia = new zanavi_osm_map_values("Serbia", "serbia.bin", 8666368L, false, 3);
	static final zanavi_osm_map_values z_Slovakia = new zanavi_osm_map_values("Slovakia", "slovakia.bin", 68912557L, false, 3);
	static final zanavi_osm_map_values z_Slovenia = new zanavi_osm_map_values("Slovenia", "slovenia.bin", 10395693L, false, 3);
	static final zanavi_osm_map_values z_Spain = new zanavi_osm_map_values("Spain", "spain.bin", 148546725L, false, 3);
	static final zanavi_osm_map_values z_Sweden = new zanavi_osm_map_values("Sweden", "sweden.bin", 73636690L, false, 3);
	static final zanavi_osm_map_values z_Switzerland = new zanavi_osm_map_values("Switzerland", "switzerland.bin", 67602527L, false, 3);
	static final zanavi_osm_map_values z_Turkey = new zanavi_osm_map_values("Turkey", "turkey.bin", 30040205L, false, 3);
	static final zanavi_osm_map_values z_Ukraine = new zanavi_osm_map_values("Ukraine", "ukraine.bin", 43276291L, false, 3);
	static final zanavi_osm_map_values z_Canari_Islands = new zanavi_osm_map_values("Canari Islands", "canari_islands.bin", 7229435L, false, 4);
	static final zanavi_osm_map_values z_India = new zanavi_osm_map_values("India", "india.bin", 41352179L, false, 5);
	static final zanavi_osm_map_values z_Israel_and_Palestine = new zanavi_osm_map_values("Israel and Palestine", "israel_and_palestine.bin", 14431019L, false, 5);
	static final zanavi_osm_map_values z_China = new zanavi_osm_map_values("China", "china.bin", 44230354L, false, 5);
	static final zanavi_osm_map_values z_Japan = new zanavi_osm_map_values("Japan", "japan.bin", 322588619L, false, 5);
	static final zanavi_osm_map_values z_Taiwan = new zanavi_osm_map_values("Taiwan", "taiwan.bin", 5009368L, false, 5);
	static final zanavi_osm_map_values z_Canada = new zanavi_osm_map_values("Canada", "canada.bin", 499312961L, false, 6);
	static final zanavi_osm_map_values z_Greenland = new zanavi_osm_map_values("Greenland", "greenland.bin", 432616L, false, 6);
	static final zanavi_osm_map_values z_Mexico = new zanavi_osm_map_values("Mexico", "mexico.bin", 26196974L, false, 6);
	static zanavi_osm_map_values z_US_Midwest = new zanavi_osm_map_values("US-Midwest", "us-midwest.bin", 460545121L, false, 27);
	static zanavi_osm_map_values z_US_Northeast = new zanavi_osm_map_values("US-Northeast", "us-northeast.bin", 197331583L, false, 27);
	static zanavi_osm_map_values z_US_Pacific = new zanavi_osm_map_values("US-Pacific", "us-pacific.bin", 11858780L, false, 27);
	static zanavi_osm_map_values z_US_South = new zanavi_osm_map_values("US-South", "us-south.bin", 765677845L, false, 27);
	static zanavi_osm_map_values z_US_West = new zanavi_osm_map_values("US-West", "us-west.bin", 494044176L, false, 27);
	static final zanavi_osm_map_values z_Alabama = new zanavi_osm_map_values("Alabama", "alabama.bin", 46035181L, false, 27);
	static final zanavi_osm_map_values z_Alaska = new zanavi_osm_map_values("Alaska", "alaska.bin", 6785486L, false, 27);
	static final zanavi_osm_map_values z_Arizona = new zanavi_osm_map_values("Arizona", "arizona.bin", 36575906L, false, 27);
	static final zanavi_osm_map_values z_Arkansas = new zanavi_osm_map_values("Arkansas", "arkansas.bin", 28352591L, false, 27);
	static final zanavi_osm_map_values z_California = new zanavi_osm_map_values("California", "california.bin", 198190467L, false, 27);
	static final zanavi_osm_map_values z_North_Carolina = new zanavi_osm_map_values("North Carolina", "north-carolina.bin", 124929760L, false, 27);
	static final zanavi_osm_map_values z_South_Carolina = new zanavi_osm_map_values("South Carolina", "south-carolina.bin", 47633210L, false, 27);
	static final zanavi_osm_map_values z_Colorado = new zanavi_osm_map_values("Colorado", "colorado.bin", 73200351L, false, 27);
	static final zanavi_osm_map_values z_North_Dakota = new zanavi_osm_map_values("North Dakota", "north-dakota.bin", 53011946L, false, 27);
	static final zanavi_osm_map_values z_South_Dakota = new zanavi_osm_map_values("South Dakota", "south-dakota.bin", 20292394L, false, 27);
	static final zanavi_osm_map_values z_District_of_Columbia = new zanavi_osm_map_values("District of Columbia", "district-of-columbia.bin", 5212731L, false, 27);
	static final zanavi_osm_map_values z_Connecticut = new zanavi_osm_map_values("Connecticut", "connecticut.bin", 7965171L, false, 27);
	static final zanavi_osm_map_values z_Delaware = new zanavi_osm_map_values("Delaware", "delaware.bin", 3323818L, false, 27);
	static final zanavi_osm_map_values z_Florida = new zanavi_osm_map_values("Florida", "florida.bin", 54112908L, false, 27);
	static final zanavi_osm_map_values z_Georgia = new zanavi_osm_map_values("Georgia", "georgia.bin", 93525831L, false, 27);
	static final zanavi_osm_map_values z_New_Hampshire = new zanavi_osm_map_values("New Hampshire", "new-hampshire.bin", 15639970L, false, 27);
	static final zanavi_osm_map_values z_Hawaii = new zanavi_osm_map_values("Hawaii", "hawaii.bin", 5056789L, false, 27);
	static final zanavi_osm_map_values z_Idaho = new zanavi_osm_map_values("Idaho", "idaho.bin", 39333659L, false, 27);
	static final zanavi_osm_map_values z_Illinois = new zanavi_osm_map_values("Illinois", "illinois.bin", 66454448L, false, 27);
	static final zanavi_osm_map_values z_Indiana = new zanavi_osm_map_values("Indiana", "indiana.bin", 28278682L, false, 27);
	static final zanavi_osm_map_values z_Iowa = new zanavi_osm_map_values("Iowa", "iowa.bin", 50760824L, false, 27);
	static final zanavi_osm_map_values z_New_Jersey = new zanavi_osm_map_values("New Jersey", "new-jersey.bin", 29183280L, false, 27);
	static final zanavi_osm_map_values z_Kansas = new zanavi_osm_map_values("Kansas", "kansas.bin", 27910209L, false, 27);
	static final zanavi_osm_map_values z_Kentucky = new zanavi_osm_map_values("Kentucky", "kentucky.bin", 51079926L, false, 27);
	static final zanavi_osm_map_values z_Louisiana = new zanavi_osm_map_values("Louisiana", "louisiana.bin", 45890527L, false, 27);
	static final zanavi_osm_map_values z_Maine = new zanavi_osm_map_values("Maine", "maine.bin", 16045000L, false, 27);
	static final zanavi_osm_map_values z_Maryland = new zanavi_osm_map_values("Maryland", "maryland.bin", 31260203L, false, 27);
	static final zanavi_osm_map_values z_Massachusetts = new zanavi_osm_map_values("Massachusetts", "massachusetts.bin", 48819722L, false, 27);
	static final zanavi_osm_map_values z_New_Mexico = new zanavi_osm_map_values("New Mexico", "new-mexico.bin", 32360275L, false, 27);
	static final zanavi_osm_map_values z_Michigan = new zanavi_osm_map_values("Michigan", "michigan.bin", 47178281L, false, 27);
	static final zanavi_osm_map_values z_Minnesota = new zanavi_osm_map_values("Minnesota", "minnesota.bin", 78611082L, false, 27);
	static final zanavi_osm_map_values z_Mississippi = new zanavi_osm_map_values("Mississippi", "mississippi.bin", 31625610L, false, 27);
	static final zanavi_osm_map_values z_Missouri = new zanavi_osm_map_values("Missouri", "missouri.bin", 50639636L, false, 27);
	static final zanavi_osm_map_values z_Montana = new zanavi_osm_map_values("Montana", "montana.bin", 28464213L, false, 27);
	static final zanavi_osm_map_values z_Nebraska = new zanavi_osm_map_values("Nebraska", "nebraska.bin", 29788541L, false, 27);
	static final zanavi_osm_map_values z_Nevada = new zanavi_osm_map_values("Nevada", "nevada.bin", 31637431L, false, 27);
	static final zanavi_osm_map_values z_Ohio = new zanavi_osm_map_values("Ohio", "ohio.bin", 51407120L, false, 27);
	static final zanavi_osm_map_values z_Oklahoma = new zanavi_osm_map_values("Oklahoma", "oklahoma.bin", 61702065L, false, 27);
	static final zanavi_osm_map_values z_Oregon = new zanavi_osm_map_values("Oregon", "oregon.bin", 44238403L, false, 27);
	static final zanavi_osm_map_values z_Pennsylvania = new zanavi_osm_map_values("Pennsylvania", "pennsylvania.bin", 62818050L, false, 27);
	static final zanavi_osm_map_values z_Rhode_Island = new zanavi_osm_map_values("Rhode Island", "rhode-island.bin", 4469038L, false, 27);
	static final zanavi_osm_map_values z_Tennessee = new zanavi_osm_map_values("Tennessee", "tennessee.bin", 34457875L, false, 27);
	static final zanavi_osm_map_values z_Texas = new zanavi_osm_map_values("Texas", "texas.bin", 122360070L, false, 27);
	static final zanavi_osm_map_values z_Utah = new zanavi_osm_map_values("Utah", "utah.bin", 22504486L, false, 27);
	static final zanavi_osm_map_values z_Vermont = new zanavi_osm_map_values("Vermont", "vermont.bin", 10310709L, false, 27);
	static final zanavi_osm_map_values z_Virginia = new zanavi_osm_map_values("Virginia", "virginia.bin", 128766172L, false, 27);
	static final zanavi_osm_map_values z_West_Virginia = new zanavi_osm_map_values("West Virginia", "west-virginia.bin", 15986587L, false, 27);
	static final zanavi_osm_map_values z_Washington = new zanavi_osm_map_values("Washington", "washington.bin", 40566463L, false, 27);
	static final zanavi_osm_map_values z_Wisconsin = new zanavi_osm_map_values("Wisconsin", "wisconsin.bin", 45505217L, false, 27);
	static final zanavi_osm_map_values z_Wyoming = new zanavi_osm_map_values("Wyoming", "wyoming.bin", 19076762L, false, 27);
	static final zanavi_osm_map_values z_New_York = new zanavi_osm_map_values("New York", "new-york.bin", 47606755L, false, 27);
	static final zanavi_osm_map_values z_USA_minor_Islands = new zanavi_osm_map_values("USA minor Islands", "usa_minor_islands.bin", 95926723L, false, 27);
	static final zanavi_osm_map_values z_Panama = new zanavi_osm_map_values("Panama", "panama.bin", 1157660L, false, 7);
	static final zanavi_osm_map_values z_Haiti_and_Dom_Rep_ = new zanavi_osm_map_values("Haiti and Dom.Rep.", "haiti_and_domrep.bin", 12902807L, false, 136);
	static final zanavi_osm_map_values z_Cuba = new zanavi_osm_map_values("Cuba", "cuba.bin", 3743027L, false, 136);
	//
	//
	//
	static final zanavi_osm_map_values[] z_OSM_MAPS = new zanavi_osm_map_values[] { z_Country_borders, z_Coastline, z_Restl_welt, z_Planet, z_Europe, z_North_America, z_USA, z_Central_America, z_South_America, z_Africa, z_Asia, z_Australia_and_Oceania, z_Caribbean, z_Albania, z_Alps, z_Andorra, z_Austria, z_Azores, z_Belarus, z_Belgium, z_Bosnia_Herzegovina, z_British_Isles, z_Bulgaria, z_Croatia, z_Cyprus, z_Czech_Republic, z_Denmark, z_Estonia, z_Faroe_Islands, z_Finland, z_France, z_Germany,
			z_Great_Britain, z_Greece, z_Hungary, z_Iceland, z_Ireland, z_Isle_of_man, z_Italy, z_Kosovo, z_Latvia, z_Liechtenstein, z_Lithuania, z_Luxembourg, z_Macedonia, z_Malta, z_Moldova, z_Monaco, z_Montenegro, z_Netherlands, z_Norway, z_Poland, z_Portugal, z_Romania, z_Russia_European_part, z_Serbia, z_Slovakia, z_Slovenia, z_Spain, z_Sweden, z_Switzerland, z_Turkey, z_Ukraine, z_Canari_Islands, z_India, z_Israel_and_Palestine, z_China, z_Japan, z_Taiwan, z_Canada, z_Greenland, z_Mexico,
			z_US_Midwest, z_US_Northeast, z_US_Pacific, z_US_South, z_US_West, z_Alabama, z_Alaska, z_Arizona, z_Arkansas, z_California, z_North_Carolina, z_South_Carolina, z_Colorado, z_North_Dakota, z_South_Dakota, z_District_of_Columbia, z_Connecticut, z_Delaware, z_Florida, z_Georgia, z_New_Hampshire, z_Hawaii, z_Idaho, z_Illinois, z_Indiana, z_Iowa, z_New_Jersey, z_Kansas, z_Kentucky, z_Louisiana, z_Maine, z_Maryland, z_Massachusetts, z_New_Mexico, z_Michigan, z_Minnesota, z_Mississippi,
			z_Missouri, z_Montana, z_Nebraska, z_Nevada, z_Ohio, z_Oklahoma, z_Oregon, z_Pennsylvania, z_Rhode_Island, z_Tennessee, z_Texas, z_Utah, z_Vermont, z_Virginia, z_West_Virginia, z_Washington, z_Wisconsin, z_Wyoming, z_New_York, z_USA_minor_Islands, z_Panama, z_Haiti_and_Dom_Rep_, z_Cuba };

	//
	//
	//
	//
	//
	public static String[] OSM_MAP_NAME_LIST_inkl_SIZE_ESTIMATE = null;
	public static String[] OSM_MAP_NAME_LIST_ondisk = null;

	public static int[] OSM_MAP_NAME_ORIG_ID_LIST = null;
	public static String[] OSM_MAP_NAME_ondisk_ORIG_LIST = null;

	private static Boolean already_inited = false;

	public Boolean stop_me = false;
	static final int SOCKET_CONNECT_TIMEOUT = 30000; // 30 secs.
	static final int SOCKET_READ_TIMEOUT = 25000; // 25 secs.
	static final int MAP_WRITE_FILE_BUFFER = 1024 * 64;
	static final int MAP_WRITE_MEM_BUFFER = 1024 * 64;
	static final int MAP_READ_FILE_BUFFER = 1024 * 64;
	static final int UPDATE_PROGRESS_EVERY_CYCLE = 12; // 8 -> is nicer, but maybe to fast for some devices
	static final int RETRIES = 70; // this many retries on map download

	static final long MAX_SINGLE_BINFILE_SIZE = 3 * 512 * 1024 * 1024; // split map at this size into pieces [1.5GB] [1.610.612.736 Bytes]	

	static final String DOWNLOAD_FILENAME = "navitmap.tmp";
	static final String MD5_DOWNLOAD_TEMPFILE = "navitmap_tmp.md5";
	static final String CAT_FILE = "maps_cat.txt";
	public static List<String> map_catalogue = new ArrayList<String>();
	static final String MAP_CAT_HEADER = "# ZANavi maps -- do not edit by hand --";
	public static final String MAP_URL_NAME_UNKNOWN = "* unknown map *";
	public static final String MAP_DISK_NAME_UNKNOWN = "-> unknown map";

	static final String MAP_FILENAME_PRI = "navitmap_001.bin";
	static final String MAP_FILENAME_SEC = "navitmap_002.bin";
	static final String MAP_FILENAME_BASE = "navitmap_%03d.bin";
	static final int MAP_MAX_FILES = 19;
	static final String MAP_FILENAME_BORDERS = "borders.bin";
	static final String MAP_FILENAME_COASTLINE = "coastline.bin";

	static long[] mapdownload_already_read = null;
	static float[] mapdownload_byte_per_second_overall = null;
	static int mapdownload_error_code = 0;
	static Boolean mapdownload_stop_all_threads = false;

	static final int MAX_MAP_COUNT = 500;

	public class ProgressThread extends Thread
	{
		Handler mHandler;
		zanavi_osm_map_values map_values;
		int map_num;
		int my_dialog_num;

		ProgressThread(Handler h, zanavi_osm_map_values map_values, int map_num2)
		{
			this.mHandler = h;
			this.map_values = map_values;
			this.map_num = map_num2;
			if (this.map_num == Navit.MAP_NUM_PRIMARY)
			{
				this.my_dialog_num = Navit.MAPDOWNLOAD_PRI_DIALOG;
			}
			else if (this.map_num == Navit.MAP_NUM_SECONDARY)
			{
				this.my_dialog_num = Navit.MAPDOWNLOAD_SEC_DIALOG;
			}
		}

		public void run()
		{
			stop_me = false;
			mapdownload_stop_all_threads = false;
			System.out.println("map_num=" + this.map_num + " v=" + map_values.map_name + " " + map_values.url);
			int exit_code = download_osm_map(mHandler, map_values, this.map_num);
			// clean up always
			File tmp_downloadfile = new File(Navit.CFG_FILENAME_PATH, DOWNLOAD_FILENAME);
			tmp_downloadfile.delete();
			for (int jkl = 1; jkl < 51; jkl++)
			{
				File tmp_downloadfileSplit = new File(Navit.CFG_FILENAME_PATH, DOWNLOAD_FILENAME + "." + String.valueOf(jkl));
				tmp_downloadfileSplit.delete();
			}
			//
			File tmp_downloadfile_md5 = new File(Navit.MAPMD5_FILENAME_PATH, MD5_DOWNLOAD_TEMPFILE);
			tmp_downloadfile_md5.delete();
			Log.d("NavitMapDownloader", "(a)removed " + tmp_downloadfile.getAbsolutePath());
			// ok, remove dialog
			Message msg = mHandler.obtainMessage();
			Bundle b = new Bundle();
			msg.what = 0;
			b.putInt("dialog_num", this.my_dialog_num);
			// only exit_code=0 will try to use the new map
			b.putInt("exit_code", exit_code);
			msg.setData(b);
			mHandler.sendMessage(msg);
		}

		public void stop_thread()
		{
			stop_me = true;
			mapdownload_stop_all_threads = true;
			Log.d("NavitMapDownloader", "stop_me -> true");
			// remove the tmp download file (if there is one)
			File tmp_downloadfile = new File(Navit.CFG_FILENAME_PATH, DOWNLOAD_FILENAME);
			tmp_downloadfile.delete();
			for (int jkl = 1; jkl < 51; jkl++)
			{
				File tmp_downloadfileSplit = new File(Navit.CFG_FILENAME_PATH, DOWNLOAD_FILENAME + "." + String.valueOf(jkl));
				tmp_downloadfileSplit.delete();
			}
			//
			File tmp_downloadfile_md5 = new File(Navit.MAPMD5_FILENAME_PATH, MD5_DOWNLOAD_TEMPFILE);
			tmp_downloadfile_md5.delete();
			Log.d("NavitMapDownloader", "(b)removed " + tmp_downloadfile.getAbsolutePath());
		}
	}

	private class MultiStreamDownloaderThread extends Thread
	{
		Boolean running = false;
		Handler handler;
		zanavi_osm_map_values map_values;
		int map_num;
		int my_dialog_num;
		int my_num = 0;
		String PATH = null;
		String PATH2 = null;
		String fileName = null;
		String final_fileName = null;
		String this_server_name = null;
		String up_map = null;
		long start_byte = 0L;
		long end_byte = 0L;

		MultiStreamDownloaderThread(Handler h, zanavi_osm_map_values map_values, int map_num2, int c, String p, String p2, String fn, String ffn, String sn, String upmap, long start_byte, long end_byte)
		{
			running = false;

			this.start_byte = start_byte;
			this.end_byte = end_byte;

			System.out.println("bytes=" + this.start_byte + ":" + this.end_byte);

			PATH = p;
			PATH2 = p2;
			fileName = fn;
			final_fileName = ffn;
			this_server_name = sn;
			up_map = upmap;
			this.my_num = c;
			this.handler = h;
			this.map_values = map_values;
			this.map_num = map_num2;
			if (this.map_num == Navit.MAP_NUM_PRIMARY)
			{
				this.my_dialog_num = Navit.MAPDOWNLOAD_PRI_DIALOG;
			}
			else if (this.map_num == Navit.MAP_NUM_SECONDARY)
			{
				this.my_dialog_num = Navit.MAPDOWNLOAD_SEC_DIALOG;
			}
			System.out.println("MultiStreamDownloaderThread " + this.my_num + " init");
		}

		public void run()
		{
			running = true;

			System.out.println("MultiStreamDownloaderThread " + this.my_num + " run");
			while (running)
			{
				if (mapdownload_stop_all_threads == true)
				{
					running = false;
					mapdownload_error_code_inc();
					break;
				}

				int try_number = 0;
				Boolean download_success = false;

				File file = new File(PATH);
				File file2 = new File(PATH2);
				File outputFile = new File(file2, fileName);
				File final_outputFile = new File(file, final_fileName);
				// tests have shown that deleting the file first is sometimes faster -> so we delete it (who knows)
				//**outputFile.delete();
				RandomAccessFile f_rnd = null;

				if (this.start_byte > (MAX_SINGLE_BINFILE_SIZE - 1))
				{
					// split file, we need to compensate
					int split_num = (int) (this.start_byte / MAX_SINGLE_BINFILE_SIZE);
					long real_start_byte = this.start_byte - (MAX_SINGLE_BINFILE_SIZE * split_num);
					f_rnd = d_open_file(PATH2 + "/" + fileName + "." + split_num, real_start_byte);
				}
				else
				{
					f_rnd = d_open_file(PATH2 + "/" + fileName, this.start_byte);
				}

				if (f_rnd == null)
				{
					Message msg = handler.obtainMessage();
					Bundle b = new Bundle();
					msg.what = 2;
					b.putInt("dialog_num", my_dialog_num);
					b.putString("text", Navit.get_text("Error downloading map!")); //TRANS
					msg.setData(b);
					handler.sendMessage(msg);

					this.running = false;
					mapdownload_error_code_inc();
					break;
					// return 1;
				}

				byte[] buffer = new byte[MAP_WRITE_MEM_BUFFER]; // buffer
				int len1 = 0;
				long already_read = this.start_byte;
				int alt = UPDATE_PROGRESS_EVERY_CYCLE; // show progress about every xx cylces
				int alt_cur = 0;
				String kbytes_per_second = "";
				long start_timestamp = System.currentTimeMillis();
				NumberFormat formatter = new DecimalFormat("00000.0");
				String eta_string = "";
				float per_second_overall = 0f;
				long bytes_remaining = 0;
				int eta_seconds = 0;

				// while -------
				while ((try_number < RETRIES) && (!download_success))
				{
					if (mapdownload_stop_all_threads == true)
					{
						running = false;
						mapdownload_error_code_inc();
						break;
					}

					if (stop_me)
					{
						// ok we need to be stopped! close all files and end
						this.running = false;
						mapdownload_error_code_inc();
						break;
						// return 2;
					}

					try_number++;
					Log.d("NavitMapDownloader", this.my_num + "download try number " + try_number);

					HttpURLConnection c = d_url_connect(map_values, this_server_name, map_num, this.my_num);
					// set http header to resume download
					c = d_url_resume_download_at(c, already_read, this.end_byte, this.my_num);

					if (try_number > 1)
					{
						// seek to resume position in download file
						// ---------------------
						// close file
						d_close_file(f_rnd);
						// open file
						if (this.start_byte > (MAX_SINGLE_BINFILE_SIZE - 1))
						{
							// split file, we need to compensate
							int split_num = (int) (already_read / MAX_SINGLE_BINFILE_SIZE);
							long real_already_read = already_read - (MAX_SINGLE_BINFILE_SIZE * split_num);
							f_rnd = d_open_file(PATH2 + "/" + fileName + "." + split_num, real_already_read);
						}
						else
						{
							f_rnd = d_open_file(PATH2 + "/" + fileName, already_read);
						}
					}

					BufferedInputStream bif = d_url_get_bif(c);
					if (bif != null)
					{
						// do the real downloading here

						// do the real downloading here
						try
						{
							// len1 -> number of bytes actually read
							//while (((len1 = bif.read(buffer)) != -1) && (already_read <= this.end_byte))
							while ((len1 = bif.read(buffer)) != -1)
							{
								if (stop_me)
								{
									// ok we need to be stopped! close all files and end
									bif.close();
									d_url_disconnect(c);
									this.running = false;
									mapdownload_error_code_inc();
									break;
									// return 2;
								}
								already_read = already_read + len1;
								alt_cur++;
								if (alt_cur > alt)
								{
									alt_cur = 0;

									Message msg = handler.obtainMessage();
									Bundle b = new Bundle();
									msg.what = 1;

									b.putInt("dialog_num", my_dialog_num);
									b.putString("title", Navit.get_text("Mapdownload")); //TRANS
									per_second_overall = (float) (already_read - this.start_byte) / (float) ((System.currentTimeMillis() - start_timestamp) / 1000);

									mapdownload_already_read[this.my_num - 1] = already_read - this.start_byte;
									mapdownload_byte_per_second_overall[this.my_num - 1] = per_second_overall;

									//b.putInt("max", (int) (this.end_byte / 1024));
									//b.putInt("cur", (int) ((already_read - this.start_byte) / 1024));
									float f1 = 0;
									long l1 = 0L;
									int k;
									for (k = 0; k < mapdownload_already_read.length; k++)
									{
										l1 = l1 + mapdownload_already_read[k];
										f1 = f1 + mapdownload_byte_per_second_overall[k];
									}
									b.putInt("max", (int) (map_values.est_size_bytes / 1024));
									b.putInt("cur", (int) (l1 / 1024));

									kbytes_per_second = formatter.format((f1 / 1024f));
									// kbytes_per_second = formatter.format((per_second_overall / 1024f));
									// bytes_remaining = this.end_byte - already_read;
									bytes_remaining = map_values.est_size_bytes - l1;
									// eta_seconds = (int) ((float) bytes_remaining / (float) per_second_overall);
									eta_seconds = (int) ((float) bytes_remaining / (float) f1);
									if (eta_seconds > 60)
									{
										eta_string = (int) (eta_seconds / 60f) + " m";
									}
									else
									{
										eta_string = eta_seconds + " s";
									}
									//b.putString("text", Navit.get_text("downloading") + ": " + map_values.map_name + "\n" + " " + (int) (already_read / 1024f / 1024f) + "Mb / " + (int) (map_values.est_size_bytes / 1024f / 1024f) + "Mb" + "\n" + " " + kbytes_per_second + "kb/s" + " " + Navit.get_text("ETA") + ": " + eta_string); //TRANS
									b.putString("text", Navit.get_text("downloading") + ": " + map_values.map_name + "\n" + " " + (int) (l1 / 1024f / 1024f) + "Mb / " + (int) (map_values.est_size_bytes / 1024f / 1024f) + "Mb" + "\n" + " " + kbytes_per_second + "kb/s" + " " + Navit.get_text("ETA") + ": " + eta_string); //TRANS
									msg.setData(b);
									handler.sendMessage(msg);

									try
									{
										Thread.sleep(20);
									}
									catch (Exception sleep_e)
									{
										sleep_e.printStackTrace();
									}
									// System.out.println("" + this.my_num + " " + already_read + " - " + (already_read - this.start_byte));
									// System.out.println("+++++++++++++ still downloading +++++++++++++");
								}
								//								if (already_read > this.end_byte)
								//								{
								//									int len2 = len1 - (int) (already_read - this.end_byte);
								//									if (len2 > 0)
								//									{
								//										f_rnd.write(buffer, 0, len2);
								//									}
								//								}
								//								else
								//								{

								// ********
								int current_split = 0;
								int next_split = 0;
								if (already_read > (MAX_SINGLE_BINFILE_SIZE - 1))
								{
									// split file, we need to compensate
									current_split = (int) ((long) (already_read - len1) / MAX_SINGLE_BINFILE_SIZE);
									next_split = (int) (already_read / MAX_SINGLE_BINFILE_SIZE);
								}

								if (current_split != next_split)
								{
									int len1_part2 = (int) (already_read % MAX_SINGLE_BINFILE_SIZE);
									int len1_part1 = len1 - len1_part2;
									// part1
									f_rnd.write(buffer, 0, len1_part1);
									// close file
									d_close_file(f_rnd);
									// open next split file (and seek to pos ZERO)
									f_rnd = d_open_file(PATH2 + "/" + fileName + "." + next_split, 0);
									// part2, only if more than ZERO bytes left to write
									if (len1_part2 > 0)
									{
										f_rnd.write(buffer, len1_part1, len1_part2);
									}
								}
								else
								{
									// actually write len1 bytes to output file
									f_rnd.write(buffer, 0, len1);
								}
								// ********

								//								}
								try
								{
									// System.out.println("" + this.my_num + " pos=" + f_rnd.getFilePointer() + " len=" + f_rnd.length());
								}
								catch (Exception e)
								{
									e.printStackTrace();
								}
							}
							d_close_file(f_rnd);

							bif.close();
							d_url_disconnect(c);

							// delete an already final filename, first
							//**final_outputFile.delete();
							// rename file to final name
							//**outputFile.renameTo(final_outputFile);

							// delete an already there md5 file, first
							//**File md5_final_filename = new File(Navit.MAPMD5_FILENAME_PATH + map_values.url + ".md5");
							//**md5_final_filename.delete();
							// rename file to final name
							//**File tmp_downloadfile_md5 = new File(Navit.MAPMD5_FILENAME_PATH, MD5_DOWNLOAD_TEMPFILE);
							//**tmp_downloadfile_md5.renameTo(md5_final_filename);

							// remove
							//**NavitMapDownloader.remove_from_cat_file(up_map);
							// remove any duplicates (junk in file)
							//**NavitMapDownloader.remove_from_cat_file_disk_name(final_fileName);
							// add to the catalogue file for downloaded maps
							//**NavitMapDownloader.add_to_cat_file(final_fileName, map_values.url);

							// ok downloaded ok, set flag!!
							download_success = true;
							this.running = false;
						}
						catch (IOException e)
						{
							Message msg = handler.obtainMessage();
							Bundle b = new Bundle();
							msg.what = 2;
							b.putInt("dialog_num", my_dialog_num);
							b.putString("text", Navit.get_text("Error downloading map, resuming")); //TRANS
							msg.setData(b);
							handler.sendMessage(msg);

							Log.d("NavitMapDownloader", this.my_num + " Error7: " + e);

							// ******* ********* D/NavitMapDownloader(  266): 1 Error7: java.io.IOException: No space left on device

							try
							{
								bif.close();
							}
							catch (IOException e1)
							{
								e1.printStackTrace();
							}
							d_url_disconnect(c);
						}
						catch (Exception e)
						{
							try
							{
								bif.close();
							}
							catch (IOException e1)
							{
								e1.printStackTrace();
							}
							d_url_disconnect(c);

							e.printStackTrace();
							if (stop_me)
							{
								// ok we need to be stopped! close all files and end
								this.running = false;
								mapdownload_error_code_inc();
								break;
								// return 2;
							}
						}
					}
					else
					// bif == null
					{
						d_url_disconnect(c);
						try
						{
							// sleep for 5 second
							Thread.sleep(5000);
						}
						catch (Exception ex)
						{
							ex.printStackTrace();
						}
					}
					// bif null ------

					if (!download_success)
					{
						try
						{
							// sleep for 5 second (also here)
							Thread.sleep(5000);
						}
						catch (Exception ex2)
						{
							ex2.printStackTrace();
						}
					}
				}
				// while -------

				try
				{
					Thread.sleep(50);
				}
				catch (InterruptedException e)
				{
					e.printStackTrace();
				}
			}
			System.out.println("MultiStreamDownloaderThread " + this.my_num + " finished");
		}
	}

	public Navit navit_jmain = null;

	public NavitMapDownloader(Navit main)
	{
		this.navit_jmain = main;
	}

	public static void init_maps_without_donate_largemaps()
	{
		if (Navit.Navit_Largemap_DonateVersion_Installed != true)
		{
			z_Planet.est_size_bytes = -2;
			z_Planet.est_size_bytes_human_string = "";
			z_Planet.text_for_select_list = z_Planet.map_name + " " + z_Planet.est_size_bytes_human_string;

			z_USA.est_size_bytes = -2;
			z_USA.est_size_bytes_human_string = "";
			z_USA.text_for_select_list = z_USA.map_name + " " + z_USA.est_size_bytes_human_string;

			z_Europe.est_size_bytes = -2;
			z_Europe.est_size_bytes_human_string = "";
			z_Europe.text_for_select_list = z_Europe.map_name + " " + z_Europe.est_size_bytes_human_string;
		}
	}

	public static void init_cat_file()
	{
		// read the file from sdcard
		read_cat_file();
		// make a copy
		List<String> temp_list = new ArrayList<String>();
		temp_list.clear();
		Iterator<String> k = map_catalogue.listIterator();
		while (k.hasNext())
		{
			temp_list.add(k.next());
		}
		int temp_list_prev_size = temp_list.size();
		Boolean[] bits = new Boolean[temp_list_prev_size];
		for (int h = 0; h < temp_list_prev_size; h++)
		{
			bits[h] = false;
		}
		// compare it with directory contents
		File map_dir = new File(Navit.MAP_FILENAME_PATH);
		if (map_dir.isDirectory())
		{
			String[] files_in_mapdir = map_dir.list();
			if (files_in_mapdir != null)
			{
				for (int i = 0; i < files_in_mapdir.length; i++)
				{
					System.out.println("found file in mapdir: " + files_in_mapdir[i]);
					// ignore filename with ":" in them
					if (!files_in_mapdir[i].contains(":"))
					{
						// use only files with ending ".bin"
						if (files_in_mapdir[i].endsWith(".bin"))
						{
							// ignore cat. file itself
							if (!files_in_mapdir[i].equals(CAT_FILE))
							{
								// ignore tmp download file
								if (!files_in_mapdir[i].equals(DOWNLOAD_FILENAME))
								{
									System.out.println("checking file in mapdir: " + files_in_mapdir[i]);
									Boolean found_in_maplist = false;
									Iterator<String> j = temp_list.listIterator();
									int t = 0;
									while (j.hasNext())
									{
										String st = j.next();
										if (st.split(":", 2)[0].equals(files_in_mapdir[i]))
										{
											found_in_maplist = true;
											bits[t] = true;
											System.out.println("found map: t=" + t + " map: " + files_in_mapdir[i]);
										}
										t++;
									}
									if (!found_in_maplist)
									{
										// if file is on sdcard but not in maplist
										// then add this line:
										//
										// line=mapfilename on sdcard:mapfilename on server
										if (files_in_mapdir[i].equals("borders.bin"))
										{
											System.out.println("adding to maplist: " + files_in_mapdir[i] + ":" + "borders.bin");
											temp_list.add(files_in_mapdir[i] + ":" + "borders.bin");
										}
										else
										{
											System.out.println("adding to maplist: " + files_in_mapdir[i] + ":" + MAP_URL_NAME_UNKNOWN);
											temp_list.add(files_in_mapdir[i] + ":" + MAP_URL_NAME_UNKNOWN);
										}
									}
								}
							}
						}
					}
				}
			}
		}
		// check for all maps that are in the maplist, but are missing from sdcard
		// use prev size, because values have been added to the end of the list!!
		for (int h = 0; h < temp_list_prev_size; h++)
		{
			if (bits[h] == false)
			{
				String unknown_map = temp_list.get(h);
				// check if its already commented out
				if (!unknown_map.startsWith("#"))
				{
					System.out.println("commenting out: h=" + h + " map: " + unknown_map);
					// temp_list.set(h, "#" + unknown_map);
					// to avoid download to wrong filename
					temp_list.set(h, "#################");
				}
			}
		}
		// use the corrected copy
		map_catalogue.clear();
		Iterator<String> m = temp_list.listIterator();
		while (m.hasNext())
		{
			map_catalogue.add(m.next());
		}
		// write the corrected file back to sdcard
		write_cat_file();
	}

	public static void read_cat_file()
	{
		//Get the text file
		File file = new File(Navit.CFG_FILENAME_PATH + CAT_FILE);

		//Read text from file
		try
		{
			BufferedReader br = new BufferedReader(new FileReader(file), 1000);
			map_catalogue.clear();
			String line;
			while ((line = br.readLine()) != null)
			{
				// line=mapfilename on sdcard:mapfilename on server
				// or
				// line=#comment
				if (!line.startsWith("#"))
				{
					if (line != null)
					{
						map_catalogue.add(line);
						System.out.println("line=" + line);
					}
				}
			}
		}
		catch (IOException e)
		{
		}
	}

	public static void write_cat_file()
	{
		//Get the text file
		File file = new File(Navit.CFG_FILENAME_PATH + CAT_FILE);
		FileOutputStream fOut = null;
		OutputStreamWriter osw = null;
		try
		{
			fOut = new FileOutputStream(file);
			osw = new OutputStreamWriter(fOut);
			osw.write(MAP_CAT_HEADER + "\n");

			Iterator<String> i = map_catalogue.listIterator();
			while (i.hasNext())
			{
				String st = i.next();
				osw.write(st + "\n");
				System.out.println("write line=" + st);
			}
			osw.close();
			fOut.close();
		}
		catch (Exception e)
		{
			e.printStackTrace(System.err);
		}
	}

	public static void add_to_cat_file(String disk_name, String server_name)
	{
		System.out.println("adding: " + disk_name + ":" + server_name);
		map_catalogue.add(disk_name + ":" + server_name);
		write_cat_file();
	}

	public static void remove_from_cat_file(String disk_name, String server_name)
	{
		System.out.println("removing: " + disk_name + ":" + server_name);
		map_catalogue.remove(disk_name + ":" + server_name);
		write_cat_file();
	}

	public static void remove_from_cat_file_disk_name(String disk_name)
	{
		System.out.println("removing: " + disk_name);

		int find_count = 0;
		String[] saved_lines = new String[50];
		for (int x = 0; x < 50; x++)
		{
			saved_lines[x] = new String();

		}

		Iterator<String> i = map_catalogue.listIterator();
		while (i.hasNext())
		{
			String st = i.next();
			if (st.split(":", 2)[0].equals(disk_name))
			{
				saved_lines[find_count] = st;
				find_count++;
			}
		}

		if (find_count == 0)
		{
			// clean up
			saved_lines = null;
			System.out.println("nothing to delete");
			return;
		}
		for (int x = 0; x < find_count; x++)
		{
			System.out.println("removing: " + saved_lines[x]);
			map_catalogue.remove(saved_lines[x]);
		}
		// clean up
		saved_lines = null;
		// write file
		write_cat_file();
	}

	public static void remove_from_cat_file(String full_line)
	{
		System.out.println("removing: " + full_line);
		map_catalogue.remove(full_line);
		write_cat_file();
	}

	public static Boolean is_in_cat_file(String disk_name, String server_name)
	{
		return map_catalogue.contains(disk_name + ":" + server_name);
	}

	public static String is_in_cat_file_disk_name(String name)
	{
		String is_here = null;
		Iterator<String> i = map_catalogue.listIterator();
		while (i.hasNext())
		{
			String st = i.next();
			if (st.split(":", 2)[0].equals(name))
			{
				// map is here
				is_here = st;
				return is_here;
			}
		}
		return is_here;
	}

	public static String is_in_cat_file_server_name(String name)
	{
		String is_here = null;
		Iterator<String> i = map_catalogue.listIterator();
		while (i.hasNext())
		{
			String st = i.next();
			if (!st.startsWith("#"))
			{
				if (st.split(":", 2)[1].equals(name))
				{
					// map is here
					is_here = st;
					return is_here;
				}
			}
		}
		return is_here;
	}

	public static int find_lowest_mapnumber_free()
	{
		int ret = MAP_MAX_FILES;
		String tmp_name = null;
		for (int j = 1; j < MAP_MAX_FILES + 1; j++)
		{
			tmp_name = String.format(MAP_FILENAME_BASE, j);
			Iterator<String> i = map_catalogue.listIterator();
			Boolean is_here = false;
			while (i.hasNext())
			{
				String st = i.next();
				if (st.split(":", 2)[0].equals(tmp_name))
				{
					// map is here
					is_here = true;
				}
			}
			if (!is_here)
			{
				ret = j;
				return j;
			}
		}
		return ret;
	}

	public static void init()
	{
		// need only init once
		if (already_inited)
		{
			return;
		}

		//String[] temp_m = new String[MAX_MAP_COUNT];
		String[] temp_ml = new String[MAX_MAP_COUNT];
		int[] temp_i = new int[MAX_MAP_COUNT];
		Boolean[] already_added = new Boolean[z_OSM_MAPS.length];
		int cur_continent = -1;
		int count = 0;
		Boolean last_was_continent = false;
		int last_continent_id = -1;
		Log.v("NavitMapDownloader", "init maps");
		for (int i = 0; i < z_OSM_MAPS.length; i++)
		{
			already_added[i] = false;
		}
		for (int i = 0; i < z_OSM_MAPS.length; i++)
		{
			//Log.v("NavitMapDownloader", "i=" + i);
			// look for continents only
			if (z_OSM_MAPS[i].is_continent)
			{
				if (!((last_was_continent) && (last_continent_id == z_OSM_MAPS[i].continent_id)))
				{
					if (count > 0)
					{
						// add a break into list
						//temp_m[count] = "*break*";
						temp_ml[count] = "======";
						temp_i[count] = -1;
						count++;
					}
				}
				last_was_continent = true;
				last_continent_id = z_OSM_MAPS[i].continent_id;

				cur_continent = z_OSM_MAPS[i].continent_id;
				if (z_OSM_MAPS[i].est_size_bytes == -2)
				{
					// only dummy entry to have a nice structure
					temp_ml[count] = z_OSM_MAPS[i].text_for_select_list;
					temp_i[count] = -1;
				}
				else
				{
					temp_ml[count] = z_OSM_MAPS[i].text_for_select_list;
					temp_i[count] = i;
				}
				count++;
				already_added[i] = true;
				Boolean skip = false;
				try
				{
					// get next item
					if ((z_OSM_MAPS[i + 1].is_continent) && (cur_continent == z_OSM_MAPS[i + 1].continent_id))
					{
						skip = true;
					}
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
				// only if not 2 contitents following each other
				if (!skip)
				{
					for (int j = 0; j < z_OSM_MAPS.length; j++)
					{
						// if (already_added[j] == null)
						if (!already_added[j])
						{
							// look for maps in that continent
							if ((z_OSM_MAPS[j].continent_id == cur_continent) && (!z_OSM_MAPS[j].is_continent))
							{
								//Log.v("NavitMapDownloader", "found map=" + j + " c=" + cur_continent);
								// add this map.
								//temp_m[count] = z_OSM_MAPS[j].map_name;
								temp_ml[count] = " * " + z_OSM_MAPS[j].text_for_select_list;
								temp_i[count] = j;
								count++;
								already_added[j] = true;
							}
						}
					}
				}
			}
			else
			{
				last_was_continent = false;
			}
		}
		// add the rest of the list (dont have a continent)
		cur_continent = 9999; // unknown
		int found = 0;
		for (int i = 0; i < z_OSM_MAPS.length; i++)
		{
			if (!already_added[i])
			{
				if (found == 0)
				{
					found = 1;
					// add a break into list
					//temp_m[count] = "*break*";
					temp_ml[count] = "======";
					temp_i[count] = -1;
					count++;
				}

				//Log.v("NavitMapDownloader", "found map(loose)=" + i + " c=" + cur_continent);
				// add this map.
				//temp_m[count] = z_OSM_MAPS[i].map_name;
				temp_ml[count] = " # " + z_OSM_MAPS[i].text_for_select_list;
				temp_i[count] = i;
				count++;
				already_added[i] = true;
			}
		}

		Log.e("NavitMapDownloader", "count=" + count);
		Log.e("NavitMapDownloader", "size1 " + z_OSM_MAPS.length);
		//Log.e("NavitMapDownloader", "size2 " + temp_m.length);
		Log.e("NavitMapDownloader", "size3 " + temp_ml.length);

		//OSM_MAP_NAME_LIST = new String[count];
		OSM_MAP_NAME_LIST_inkl_SIZE_ESTIMATE = new String[count];
		OSM_MAP_NAME_ORIG_ID_LIST = new int[count];

		for (int i = 0; i < count; i++)
		{
			//OSM_MAP_NAME_LIST[i] = temp_m[i];
			OSM_MAP_NAME_ORIG_ID_LIST[i] = temp_i[i];
			OSM_MAP_NAME_LIST_inkl_SIZE_ESTIMATE[i] = temp_ml[i];
		}

		already_inited = true;
	}

	public static void init_ondisk_maps()
	{
		Log.v("NavitMapDownloader", "init ondisk maps");

		OSM_MAP_NAME_LIST_ondisk = new String[map_catalogue.size()];
		OSM_MAP_NAME_ondisk_ORIG_LIST = new String[map_catalogue.size()];

		Iterator<String> i = map_catalogue.listIterator();
		int c = 0;
		String t;
		while (i.hasNext())
		{
			String st = i.next();

			if (!st.startsWith("#"))
			{
				// full line <on disk name:server filename>
				OSM_MAP_NAME_ondisk_ORIG_LIST[c] = st;
				// server file name
				OSM_MAP_NAME_LIST_ondisk[c] = null;
				try
				{
					t = st.split(":", 2)[1];

					for (int j = 0; j < z_OSM_MAPS.length; j++)
					{
						if (z_OSM_MAPS[j].url.equals(t))
						{
							OSM_MAP_NAME_LIST_ondisk[c] = z_OSM_MAPS[j].map_name;
						}
					}
					if (OSM_MAP_NAME_LIST_ondisk[c] == null)
					{
						// for unkown maps
						OSM_MAP_NAME_LIST_ondisk[c] = st.split(":", 2)[0] + MAP_DISK_NAME_UNKNOWN;
					}
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
			}
			c++;
		}
	}

	public int download_osm_map(Handler handler, zanavi_osm_map_values map_values, int map_num3)
	{
		int exit_code = 1;

		int my_dialog_num = Navit.MAPDOWNLOAD_PRI_DIALOG;
		if (map_num3 == Navit.MAP_NUM_PRIMARY)
		{
			my_dialog_num = Navit.MAPDOWNLOAD_PRI_DIALOG;
		}
		else if (map_num3 == Navit.MAP_NUM_SECONDARY)
		{
			my_dialog_num = Navit.MAPDOWNLOAD_SEC_DIALOG;
		}

		Message msg = handler.obtainMessage();
		Bundle b = new Bundle();
		msg.what = 1;
		b.putInt("max", 20); // use a dummy number here
		b.putInt("cur", 0);
		b.putInt("dialog_num", my_dialog_num);
		b.putString("title", Navit.get_text("Mapdownload")); //TRANS
		b.putString("text", Navit.get_text("downloading") + ": " + map_values.map_name); //TRANS
		msg.setData(b);
		handler.sendMessage(msg);

		// output filename
		String PATH = Navit.MAP_FILENAME_PATH;
		String PATH2 = Navit.CFG_FILENAME_PATH;
		String fileName = DOWNLOAD_FILENAME;
		String final_fileName = "xxx";

		Boolean mode_update = false;
		String up_map = null;

		if (map_values.url.equals("borders.bin"))
		{
			final_fileName = MAP_FILENAME_BORDERS;
			mode_update = true;
			up_map = is_in_cat_file_server_name("borders.bin");
		}
		else if (map_values.url.equals("coastline.bin"))
		{
			final_fileName = MAP_FILENAME_COASTLINE;
			mode_update = true;
			up_map = is_in_cat_file_server_name("coastline.bin");
		}
		else
		{
			// is it an update?
			up_map = is_in_cat_file_server_name(map_values.url);
			if (up_map == null)
			{
				final_fileName = String.format(MAP_FILENAME_BASE, find_lowest_mapnumber_free());
			}
			else
			{
				final_fileName = up_map.split(":", 2)[0];
				mode_update = true;
			}
		}

		System.out.println("update=" + mode_update);
		System.out.println("final_fileName=" + final_fileName);
		System.out.println("up_map=" + up_map);

		String this_server_name = d_get_servername();
		if (this_server_name == null)
		{
			msg = handler.obtainMessage();
			b = new Bundle();
			msg.what = 2;
			b.putInt("dialog_num", my_dialog_num);
			b.putString("text", Navit.get_text("Error downloading map!")); //TRANS
			msg.setData(b);
			handler.sendMessage(msg);

			return 1;
		}

		String md5_server = d_get_md5_from_server(map_values, this_server_name, map_num3);
		if (md5_server == null)
		{
			msg = handler.obtainMessage();
			b = new Bundle();
			msg.what = 2;
			b.putInt("dialog_num", my_dialog_num);
			b.putString("text", Navit.get_text("Error downloading map!")); //TRANS
			msg.setData(b);
			handler.sendMessage(msg);

			return 1;
		}

		// on disk md5 can be "null" , when downloading new map
		String md5_disk = d_get_md5_from_disk(map_values, this_server_name, map_num3);

		if (d_match_md5sums(md5_disk, md5_server))
		{
			// ok we have a match, no need to update!
			msg = handler.obtainMessage();
			b = new Bundle();
			msg.what = 2;
			b.putInt("dialog_num", my_dialog_num);
			b.putString("text", Navit.get_text("Map already up to date")); //TRANS
			msg.setData(b);
			handler.sendMessage(msg);

			Log.d("NavitMapDownloader", "MD5 matches, no need to update map");
			return 11;
		}

		long real_file_size = d_get_real_download_filesize(map_values, this_server_name, map_num3);
		if (real_file_size <= 0)
		{
			msg = handler.obtainMessage();
			b = new Bundle();
			msg.what = 2;
			b.putInt("dialog_num", my_dialog_num);
			b.putString("text", Navit.get_text("Error downloading map!")); //TRANS
			msg.setData(b);
			handler.sendMessage(msg);

			return 1;
		}
		map_values.est_size_bytes = real_file_size;

		// check if file fits onto maps dir
		// check if file fits onto maps dir
		try
		{
			long avail_space = NavitAvailableSpaceHandler.getExternalAvailableSpaceInBytes(Navit.MAP_FILENAME_PATH);
			System.out.println("avail space=" + avail_space + " map size=" + real_file_size);
			if (avail_space <= real_file_size)
			{
				Message msg2 = Navit.Navit_progress_h.obtainMessage();
				Bundle b2 = new Bundle();
				msg2.what = 17;
				msg2.setData(b2);
				Navit.Navit_progress_h.sendMessage(msg2);
			}
		}
		catch (Exception e)
		{
			// just in case the device does not support this,
			// we catch the exception and continue with the download
			e.printStackTrace();
		}
		// check if file fits onto maps dir
		// check if file fits onto maps dir

		int num_threads = 1;
		long bytes_diff = 0L;
		long bytes_leftover = 0;
		if (map_values.est_size_bytes < 1000000)
		{
			num_threads = 1;
			bytes_diff = map_values.est_size_bytes;
		}
		else
		{
			if (this_server_name.equals("zanavi.noaccess.de"))
			{
				// use only 1 thread on this server
				num_threads = 1;
				bytes_diff = map_values.est_size_bytes;
			}
			else
			{
				num_threads = MULTI_NUM_THREADS;
				bytes_diff = (long) (map_values.est_size_bytes / num_threads);
				if (bytes_diff * num_threads < map_values.est_size_bytes)
				{
					bytes_leftover = map_values.est_size_bytes - (bytes_diff * num_threads);
					System.out.println("bytes_leftover=" + bytes_leftover);
				}
			}
		}

		// stupid workaround to have this value available :-(
		MULTI_NUM_THREADS_LOCAL = num_threads;

		System.out.println("bytes_diff=" + bytes_diff);

		Boolean split_mapfile = false;
		int num_splits = 0;
		// check if we need to split the file into pieces
		if (map_values.est_size_bytes > MAX_SINGLE_BINFILE_SIZE)
		{
			split_mapfile = true;
			num_splits = (int) ((map_values.est_size_bytes - 1) / MAX_SINGLE_BINFILE_SIZE);
		}
		System.out.println("split_mapfile=" + split_mapfile);
		System.out.println("num_splits=" + num_splits);
		// check if we need to split the file into pieces

		File file99 = new File(PATH2);
		File outputFile = new File(file99, fileName);
		outputFile.delete();

		for (int jkl = 1; jkl < 51; jkl++)
		{
			File outputFileSplit = new File(file99, fileName + "." + String.valueOf(jkl));
			System.out.println("delete:" + file99 + "/" + fileName + "." + String.valueOf(jkl));
			outputFileSplit.delete();
		}

		// pre create the big file
		msg = handler.obtainMessage();
		b = new Bundle();
		msg.what = 1;
		b.putInt("max", 20); // use a dummy number here
		b.putInt("cur", 0);
		b.putInt("dialog_num", my_dialog_num);
		b.putString("title", Navit.get_text("Mapdownload")); //TRANS
		b.putString("text", Navit.get_text("Creating outputfile, long time")); //TRANS
		msg.setData(b);
		handler.sendMessage(msg);

		d_pre_create_file(PATH2 + fileName, map_values.est_size_bytes, handler, my_dialog_num);

		//
		//
		MultiStreamDownloaderThread[] m = new MultiStreamDownloaderThread[num_threads];
		int k;
		mapdownload_error_code_clear();
		mapdownload_already_read = new long[num_threads];
		mapdownload_byte_per_second_overall = new float[num_threads];
		for (k = 0; k < num_threads; k++)
		{
			mapdownload_already_read[k] = 0;
			mapdownload_byte_per_second_overall[k] = 0;
		}

		// start downloader threads here --------------------------
		// start downloader threads here --------------------------
		for (k = 0; k < num_threads; k++)
		{
			if (k == (num_threads - 1))
			{
				m[k] = new MultiStreamDownloaderThread(handler, map_values, map_num3, k + 1, PATH, PATH2, fileName, final_fileName, this_server_name, up_map, bytes_diff * k, map_values.est_size_bytes);
			}
			else
			{
				m[k] = new MultiStreamDownloaderThread(handler, map_values, map_num3, k + 1, PATH, PATH2, fileName, final_fileName, this_server_name, up_map, bytes_diff * k, bytes_diff * (k + 1));
			}
			m[k].start();
		}

		// wait for downloader threads to finish --------------------------
		for (k = 0; k < num_threads; k++)
		{
			try
			{
				m[k].join();
			}
			catch (InterruptedException e)
			{
				e.printStackTrace();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}

		if (mapdownload_error_code > 0)
		{
			mapdownload_error_code_clear();
			return 97;
		}
		//
		//
		// calc md5sum on device on print it to STDOUT (unless file was split into pieces)
		if (!split_mapfile)
		{
			System.out.println("MD5 ok **start*");
			String md5sum_local_calculated = calc_md5sum_on_device(handler, my_dialog_num, map_values.est_size_bytes);
			if (!d_match_md5sums(md5sum_local_calculated, md5_server))
			{
				// some problem with download
				msg = handler.obtainMessage();
				b = new Bundle();
				msg.what = 2;
				b.putInt("dialog_num", my_dialog_num);
				b.putString("text", Navit.get_text("MD5 mismatch")); //TRANS
				msg.setData(b);
				handler.sendMessage(msg);

				outputFile.delete();
				File tmp_downloadfile_md5 = new File(Navit.MAPMD5_FILENAME_PATH, MD5_DOWNLOAD_TEMPFILE);
				tmp_downloadfile_md5.delete();

				Log.d("NavitMapDownloader", "MD5 mismatch!!");
				System.out.println("MD5 mismatch ######");
				return 12;
			}
			else
			{
				Log.d("NavitMapDownloader", "MD5 ok");
				System.out.println("MD5 ok ******");
			}
			System.out.println("MD5 ok **end*");
		}
		//
		File file = new File(PATH);
		File final_outputFile = new File(file, final_fileName);
		// delete an already final filename, first
		final_outputFile.delete();
		// delete split files
		for (int jkl = 1; jkl < 51; jkl++)
		{
			File outputFileSplit = new File(file, final_fileName + "." + String.valueOf(jkl));
			System.out.println("delete final filename:" + file + "/" + final_fileName + "." + String.valueOf(jkl));
			outputFileSplit.delete();
		}
		// rename file to final name
		outputFile.renameTo(final_outputFile);
		if (split_mapfile)
		{
			for (int jkl = 1; jkl < (num_splits + 1); jkl++)
			{
				File outputFileSplit = new File(file, final_fileName + "." + String.valueOf(jkl));
				File outputFileSplitSrc = new File(file99, fileName + "." + String.valueOf(jkl));
				System.out.println("rename:" + outputFileSplitSrc + " to:" + outputFileSplit);
				outputFileSplitSrc.renameTo(outputFileSplit);
			}
		}

		// delete an already there md5 file, first
		File md5_final_filename = new File(Navit.MAPMD5_FILENAME_PATH + map_values.url + ".md5");
		md5_final_filename.delete();
		// rename file to final name
		File tmp_downloadfile_md5 = new File(Navit.MAPMD5_FILENAME_PATH, MD5_DOWNLOAD_TEMPFILE);
		tmp_downloadfile_md5.renameTo(md5_final_filename);

		// remove
		NavitMapDownloader.remove_from_cat_file(up_map);
		// remove any duplicates (junk in file)
		NavitMapDownloader.remove_from_cat_file_disk_name(final_fileName);
		// add to the catalogue file for downloaded maps
		NavitMapDownloader.add_to_cat_file(final_fileName, map_values.url);

		//
		//

		msg = handler.obtainMessage();
		b = new Bundle();
		msg.what = 1;
		b.putInt("max", (int) (map_values.est_size_bytes / 1024));
		b.putInt("cur", (int) (map_values.est_size_bytes / 1024));
		b.putInt("dialog_num", my_dialog_num);
		b.putString("title", Navit.get_text("Mapdownload")); //TRANS
		b.putString("text", map_values.map_name + " " + Navit.get_text("ready")); //TRANS
		msg.setData(b);
		handler.sendMessage(msg);

		Log.d("NavitMapDownloader", "success");
		exit_code = 0;

		return exit_code;
	}

	private void trust_Every_ssl_cert()
	{
		// NEVER enable this on a production release!!!!!!!!!!
		try
		{
			HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier()
			{
				public boolean verify(String hostname, SSLSession session)
				{
					Log.d("NavitMapDownloader", "DANGER !!! trusted hostname=" + hostname + " DANGER !!!");
					// return true -> mean we trust this cert !! DANGER !! DANGER !!
					return true;
				}
			});
			SSLContext context = SSLContext.getInstance("TLS");
			context.init(null, new X509TrustManager[] { new X509TrustManager()
			{
				public java.security.cert.X509Certificate[] getAcceptedIssuers()
				{
					return new java.security.cert.X509Certificate[0];
				}

				@Override
				public void checkClientTrusted(java.security.cert.X509Certificate[] chain, String authType) throws java.security.cert.CertificateException
				{
				}

				@Override
				public void checkServerTrusted(java.security.cert.X509Certificate[] chain, String authType) throws java.security.cert.CertificateException
				{
				}
			} }, new SecureRandom());
			HttpsURLConnection.setDefaultSSLSocketFactory(context.getSocketFactory());
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		// NEVER enable this on a production release!!!!!!!!!!
	}

	public String d_get_servername()
	{
		// this is only for debugging
		// NEVER enable this on a production release!!!!!!!!!!
		// NEVER enable this on a production release!!!!!!!!!!
		// **** trust_Every_ssl_cert();
		// NEVER enable this on a production release!!!!!!!!!!
		// NEVER enable this on a production release!!!!!!!!!!

		String servername = null;
		try
		{
			URL url = new URL(ZANAVI_MAPS_SEVERTEXT_URL);
			System.out.println(ZANAVI_MAPS_SEVERTEXT_URL);

			HttpURLConnection c = (HttpURLConnection) url.openConnection();
			String ua_ = Navit.UserAgentString_bind.replace("@__THREAD__@", "0" + "T" + MULTI_NUM_THREADS_LOCAL);
			c.addRequestProperty("User-Agent", ua_);
			c.addRequestProperty("Pragma", "no-cache");

			c.setRequestMethod("GET");
			c.setDoOutput(true);
			c.setReadTimeout(SOCKET_READ_TIMEOUT);
			c.setConnectTimeout(SOCKET_CONNECT_TIMEOUT);
			try
			{
				c.connect();
				BufferedReader in = new BufferedReader(new InputStreamReader(c.getInputStream()), 4096);
				String str;
				str = in.readLine();
				if (str != null)
				{
					if (str.length() > 2)
					{
						System.out.println("from server=" + str);
						servername = str;
					}
				}
				in.close();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			c.disconnect();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		return servername;
	}

	public String d_get_md5_from_server(zanavi_osm_map_values map_values, String servername, int map_num3)
	{
		// try to get MD5 file
		String md5_from_server = null;
		try
		{
			URL url = new URL(ZANAVI_MAPS_BASE_URL_PROTO + servername + ZANAVI_MAPS_BASE_URL_WO_SERVERNAME + map_values.url + ".md5");
			System.out.println("md5 url:" + ZANAVI_MAPS_BASE_URL_PROTO + servername + ZANAVI_MAPS_BASE_URL_WO_SERVERNAME + map_values.url + ".md5");
			HttpURLConnection c = (HttpURLConnection) url.openConnection();
			String ua_ = Navit.UserAgentString_bind.replace("@__THREAD__@", "0" + "T" + MULTI_NUM_THREADS_LOCAL);
			c.addRequestProperty("User-Agent", ua_);
			c.addRequestProperty("Pragma", "no-cache");

			c.setRequestMethod("GET");
			c.setDoOutput(true);
			c.setReadTimeout(SOCKET_READ_TIMEOUT);
			c.setConnectTimeout(SOCKET_CONNECT_TIMEOUT);
			try
			{
				c.connect();
				BufferedReader in = new BufferedReader(new InputStreamReader(c.getInputStream()), 4096);
				String str;
				str = in.readLine();
				if (str != null)
				{
					if (str.length() > 5)
					{
						File tmp_downloadfile_md5 = new File(Navit.MAPMD5_FILENAME_PATH, MD5_DOWNLOAD_TEMPFILE);
						tmp_downloadfile_md5.delete();
						System.out.println("md5 from server=" + str);
						FileOutputStream fos = null;
						try
						{
							fos = new FileOutputStream(tmp_downloadfile_md5);
							fos.write(str.getBytes());
							fos.close();
							md5_from_server = str;
						}
						catch (FileNotFoundException e1)
						{
							e1.printStackTrace();
						}
					}
				}
				in.close();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			c.disconnect();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		// try to get MD5 file
		return md5_from_server;
	}

	public long d_get_real_download_filesize(zanavi_osm_map_values map_values, String servername, int map_num3)
	{
		long real_size_bytes = 0;
		try
		{
			URL url = new URL(ZANAVI_MAPS_BASE_URL_PROTO + servername + ZANAVI_MAPS_BASE_URL_WO_SERVERNAME + map_values.url);
			System.out.println("url1:" + ZANAVI_MAPS_BASE_URL_PROTO + servername + ZANAVI_MAPS_BASE_URL_WO_SERVERNAME + map_values.url);
			HttpURLConnection c = (HttpURLConnection) url.openConnection();
			String ua_ = Navit.UserAgentString_bind.replace("@__THREAD__@", "0" + "T" + MULTI_NUM_THREADS_LOCAL);
			c.addRequestProperty("User-Agent", ua_);
			c.addRequestProperty("Pragma", "no-cache");

			c.setRequestMethod("GET");
			c.setDoOutput(true);
			c.setReadTimeout(SOCKET_READ_TIMEOUT);
			c.setConnectTimeout(SOCKET_CONNECT_TIMEOUT);
			// real_size_bytes = c.getContentLength(); -> only returns "int" value, its an android bug
			try
			{
				c.connect();
				System.out.println("header content-length=" + c.getHeaderField("content-length"));
				real_size_bytes = Long.parseLong(c.getHeaderField("content-length"));
				Log.d("NavitMapDownloader", "real_size_bytes=" + real_size_bytes);
			}
			catch (Exception e)
			{
				e.printStackTrace();
				Log.d("NavitMapDownloader", "error parsing content-length header field");
			}
			c.disconnect();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return real_size_bytes;
	}

	public String d_get_md5_from_disk(zanavi_osm_map_values map_values, String servername, int map_num3)
	{
		String md5_on_disk = null;

		// try to read MD5 from disk - if it fails dont worry!!
		File md5_final_filename = new File(Navit.MAPMD5_FILENAME_PATH + map_values.url + ".md5");
		InputStream in2 = null;
		try
		{
			in2 = new BufferedInputStream(new FileInputStream(md5_final_filename));
			InputStreamReader inputreader = new InputStreamReader(in2);
			BufferedReader buffreader = new BufferedReader(inputreader, 4096);
			String tmp = buffreader.readLine();
			if (tmp != null)
			{
				if (tmp.length() > 5)
				{
					md5_on_disk = tmp;
					System.out.println("MD5 on disk=" + md5_on_disk);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if (in2 != null)
			{
				try
				{
					in2.close();
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
			}
		}
		// try to read MD5 from disk - if it fails dont worry!!

		return md5_on_disk;
	}

	public Boolean d_match_md5sums(String md5_1, String md5_2)
	{
		Boolean md5_match = false;
		//
		// check md5 sum
		//
		if ((md5_1 != null) && (md5_2 != null) && (md5_1.equals(md5_2)))
		{
			md5_match = true;
		}
		//
		// check md5 sum
		//
		return md5_match;
	}

	public HttpURLConnection d_url_connect(zanavi_osm_map_values map_values, String servername, int map_num3, int current_thread_num)
	{
		URL url = null;
		HttpURLConnection c = null;
		try
		{
			url = new URL(ZANAVI_MAPS_BASE_URL_PROTO + servername + ZANAVI_MAPS_BASE_URL_WO_SERVERNAME + map_values.url);
			System.out.println("url2:" + ZANAVI_MAPS_BASE_URL_PROTO + servername + ZANAVI_MAPS_BASE_URL_WO_SERVERNAME + map_values.url);
			c = (HttpURLConnection) url.openConnection();
			String ua_ = Navit.UserAgentString_bind.replace("@__THREAD__@", "" + current_thread_num + "T" + MULTI_NUM_THREADS_LOCAL);
			c.addRequestProperty("User-Agent", ua_);
			// c.addRequestProperty("Pragma", "no-cache");
			c.setRequestMethod("GET");
			c.setDoOutput(true);
			c.setReadTimeout(SOCKET_READ_TIMEOUT);
			c.setConnectTimeout(SOCKET_CONNECT_TIMEOUT);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			c = null;
		}
		return c;
	}

	public HttpURLConnection d_url_resume_download_at(HttpURLConnection c, long old_download_size, int num)
	{
		c.setRequestProperty("Range", "bytes=" + old_download_size + "-");
		Log.d("NavitMapDownloader", num + " resuming download at " + old_download_size + " bytes");
		return c;
	}

	public HttpURLConnection d_url_resume_download_at(HttpURLConnection c, long old_download_size, long end_size, int num)
	{
		c.setRequestProperty("Range", "bytes=" + old_download_size + "-" + end_size);
		Log.d("NavitMapDownloader", num + "resuming download at " + old_download_size + " bytes" + ":" + end_size);
		return c;
	}

	public BufferedInputStream d_url_get_bif(HttpURLConnection c)
	{
		InputStream is = null;
		BufferedInputStream bif = null;
		try
		{
			c.connect();
			is = c.getInputStream();
			bif = new BufferedInputStream(is, MAP_READ_FILE_BUFFER); // buffer
		}
		catch (FileNotFoundException f)
		{
			// map file is not on server!!
			try
			{
				c.disconnect();
			}
			catch (Exception x)
			{
				x.printStackTrace();
			}
			System.out.println("map file is not on server!");
			f.printStackTrace();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		return bif;
	}

	public void d_url_disconnect(HttpURLConnection c)
	{
		try
		{
			c.disconnect();
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}

	public void d_pre_create_file(String filename, long size, Handler handler, int my_dialog_num)
	{
		RandomAccessFile f = null;
		long size_2 = size - 2;

		if (size > MAX_SINGLE_BINFILE_SIZE)
		{
			// skip this step with large mapfiles (or implement handling of split files)
			return;
		}

		class FileProgress extends Thread
		{
			Handler handler;
			String file;
			int my_dialog_num;
			long file_size;
			Boolean running = false;

			FileProgress(Handler h, String f, int dn, long fsize)
			{
				handler = h;
				file = f;
				my_dialog_num = dn;
				file_size = fsize;
				running = false;
			}

			public void run()
			{
				Message msg;
				Bundle b;
				running = true;
				File f = null;
				while (running)
				{
					if (mapdownload_stop_all_threads)
					{
						System.out.println("FileProgress:mapdownload_stop_all_threads");
						break;
					}

					try
					{
						f = new File(file);
						long cur_size = f.length();
						// System.out.println("cur_size=" + cur_size);
						msg = handler.obtainMessage();
						b = new Bundle();
						msg.what = 1;
						b.putInt("max", (int) (file_size / 1000));
						b.putInt("cur", (int) (cur_size / 1000));
						b.putInt("dialog_num", my_dialog_num);
						b.putString("title", Navit.get_text("Mapdownload")); //TRANS
						b.putString("text", Navit.get_text("Creating outputfile, long time")); //TRANS
						msg.setData(b);
						handler.sendMessage(msg);
					}
					catch (Exception e)
					{
						e.printStackTrace();
					}
					if (running)
					{
						try
						{
							Thread.sleep(700);
						}
						catch (InterruptedException e)
						{
							e.printStackTrace();
						}
					}
				}
			}

			public void stop_me()
			{
				running = false;
			}
		}

		FileProgress fp = new FileProgress(handler, filename, my_dialog_num, size);
		fp.start();

		try
		{
			f = new RandomAccessFile(filename, "rw");
			if (size_2 > 1900000000L)
			{
				f.seek(1900000000L);
				System.out.println("pre 1");
				f.writeByte(1);
				System.out.println("pre 2");
				f.seek(1900000000L);
				System.out.println("pre 3");
				int buf_size = 1000 * 32;
				byte[] buffer_seek = new byte[buf_size];
				int num_loops = (int) ((size_2 - 1900000000L - 1) / buf_size);
				int j = 0;
				for (j = 0; j < num_loops; j++)
				{
					f.write(buffer_seek);
					try
					{
						Thread.sleep(2);
					}
					catch (Exception x)
					{
						x.printStackTrace();
					}
				}

				long this_fp = 1900000000L + (num_loops * buf_size);
				System.out.println("pre 4 " + this_fp);
				buf_size = (int) (size - this_fp) - 1;
				if (buf_size > 0)
				{
					buffer_seek = new byte[buf_size];
					f.write(buffer_seek);
				}
				System.out.println("pre 5");

				// int skipped = f.skipBytes((int) (size_2 - 1900000000L));
			}
			else
			{
				System.out.println("pre 6");
				f.seek(size_2);
				System.out.println("pre 7");
			}
			System.out.println("pre 8");
			f.writeByte(1);
			// ****EEEE**** W/System.err(  266): java.io.IOException: No space left on device
			System.out.println("pre 9");

			try
			{
				System.out.println("f len=" + f.length());
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}

			f.close();
			System.out.println("pre 10");
		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
		}
		catch (Exception e)
		{
			e.printStackTrace();
			// ****EEEE**** W/System.err(  266): java.io.IOException: No space left on device
		}

		fp.stop_me();

		Message msg = handler.obtainMessage();
		Bundle b = new Bundle();
		msg.what = 1;
		b.putInt("max", (int) (size / 1000));
		b.putInt("cur", (int) (size / 1000));
		b.putInt("dialog_num", my_dialog_num);
		b.putString("title", Navit.get_text("Mapdownload")); //TRANS
		b.putString("text", Navit.get_text("Creating outputfile, wait")); //TRANS
		msg.setData(b);
		handler.sendMessage(msg);
	}

	public RandomAccessFile d_open_file(String filename, long pos)
	{
		RandomAccessFile f = null;
		System.out.println("seek (start):" + pos);
		try
		{
			f = new RandomAccessFile(filename, "rw");
			if (pos > 1900000000L)
			{
				System.out.println("open file: 1");
				f.seek(1900000000L);
				System.out.println("open file: 2");

				int buf_size = 1000 * 64;
				byte[] buffer_seek = new byte[buf_size];
				int num_loops = (int) ((pos - 1900000000L - 1) / buf_size);
				int j = 0;
				for (j = 0; j < num_loops; j++)
				{
					f.readFully(buffer_seek);
					try
					{
						Thread.sleep(2);
					}
					catch (Exception x)
					{
						x.printStackTrace();
					}
				}
				long this_fp = 1900000000L + (num_loops * buf_size);
				System.out.println("open file: 3 " + this_fp);
				buf_size = (int) (pos - this_fp);
				if (buf_size > 0)
				{
					buffer_seek = new byte[buf_size];
					f.readFully(buffer_seek);
				}
				System.out.println("open file: 4");

				// int skipped = f.skipBytes((int) (pos - 1900000000L));
				System.out.println("open file: 5");
			}
			else
			{
				System.out.println("open file: 6");
				f.seek(pos);
				System.out.println("open file: 7");
			}
		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		System.out.println("seek (end):" + pos);

		try
		{
			System.out.println("f len(seek)=" + f.length());
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		return f;
	}

	public void d_close_file(RandomAccessFile f)
	{
		try
		{
			System.out.println("f len=" + f.length());
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		try
		{
			f.close();
			System.out.println("d_close_file:f.close()");
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	public static synchronized void mapdownload_error_code_inc()
	{
		mapdownload_error_code++;
	}

	public static void mapdownload_error_code_clear()
	{
		mapdownload_error_code = 0;
	}

	public String calc_md5sum_on_device(Handler handler, int my_dialog_num, long size)
	{
		String md5sum = null;

		if (size > MAX_SINGLE_BINFILE_SIZE)
		{
			// skip this step with large mapfiles (or implement handling of split files)
			return null;
		}

		try
		{
			String s = "";
			Message msg = null;
			Bundle b = null;
			int size2 = (int) (size / 1000);
			long cur_pos = 0L;

			// Create MD5 Hash
			MessageDigest digest = java.security.MessageDigest.getInstance("MD5");

			InputStream fis = null;
			try
			{
				fis = new FileInputStream(Navit.CFG_FILENAME_PATH + DOWNLOAD_FILENAME);
			}
			catch (FileNotFoundException e)
			{
				e.printStackTrace();
			}
			byte[] buffer = new byte[1024 * 32];
			int numRead = 0;
			do
			{
				if (mapdownload_stop_all_threads)
				{
					System.out.println("calc_md5sum_on_device 1:mapdownload_stop_all_threads");
					break;
				}

				try
				{
					numRead = fis.read(buffer);
				}
				catch (IOException e)
				{
					e.printStackTrace();
				}
				if (numRead > 0)
				{
					try
					{
						// allow to catch breath
						Thread.sleep(15);
					}
					catch (InterruptedException e)
					{
						e.printStackTrace();
					}
					digest.update(buffer, 0, numRead);
					cur_pos = cur_pos + numRead;
				}

				msg = handler.obtainMessage();
				b = new Bundle();
				msg.what = 1;
				b.putInt("max", size2);
				b.putInt("cur", (int) (cur_pos / 1000));
				b.putInt("dialog_num", my_dialog_num);
				b.putString("title", Navit.get_text("Mapdownload")); //TRANS
				b.putString("text", Navit.get_text("generating MD5 checksum")); //TRANS
				msg.setData(b);
				handler.sendMessage(msg);

			}
			while (numRead != -1);

			msg = handler.obtainMessage();
			b = new Bundle();
			msg.what = 1;
			b.putInt("max", size2);
			b.putInt("cur", size2);
			b.putInt("dialog_num", my_dialog_num);
			b.putString("title", Navit.get_text("Mapdownload")); //TRANS
			b.putString("text", Navit.get_text("generating MD5 checksum")); //TRANS
			msg.setData(b);
			handler.sendMessage(msg);

			try
			{
				fis.close();
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}

			if (mapdownload_stop_all_threads)
			{
				System.out.println("calc_md5sum_on_device 2:mapdownload_stop_all_threads");
				return null;
			}

			byte messageDigest[] = digest.digest();
			// Create Hex String
			StringBuffer hexString = new StringBuffer();
			String t = "";
			for (int i = 0; i < messageDigest.length; i++)
			{
				t = Integer.toHexString(0xFF & messageDigest[i]);
				if (t.length() == 1)
				{
					t = "0" + t;
				}
				hexString.append(t);
			}
			md5sum = hexString.toString();
			System.out.println("md5sum local=" + md5sum);
		}
		catch (NoSuchAlgorithmException e)
		{
			e.printStackTrace();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return md5sum;
	}
}
