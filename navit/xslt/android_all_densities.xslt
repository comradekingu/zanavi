<?xml version="1.0"?>
<xsl:transform version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude">
        <xsl:output method="xml" doctype-system="navit.dtd" cdata-section-elements="gui"/>
		<xsl:variable name="OSD_FACTOR_">
			<xsl:choose>
				<xsl:when test="string-length($OSD_FACTOR)"><xsl:value-of select="$OSD_FACTOR"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="CAR_FACTOR_">
			<xsl:choose>
				<xsl:when test="string-length($CAR_FACTOR)"><xsl:value-of select="$CAR_FACTOR"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	<xsl:include href="default_plugins.xslt"/>
	<!--<xsl:include href="map_sdcard_navitmap_bin.xslt"/>-->
	<xsl:include href="map_secondary_sdcard_navitmap_bin.xslt"/>
	<xsl:include href="osd_android_minimum.xslt"/>
        <xsl:template match="/config/plugins/plugin[1]" priority="100">
		<plugin path="$NAVIT_PREFIX/lib/libgraphics_android.so" ondemand="no"/>
		<xsl:text>&#x0A;        </xsl:text>
		<plugin path="$NAVIT_PREFIX/lib/libvehicle_android.so" ondemand="no"/>
		<xsl:text>&#x0A;        </xsl:text>
		<plugin path="$NAVIT_PREFIX/lib/libvehicle_demo.so" ondemand="no"/>
		<xsl:text>&#x0A;        </xsl:text>
		<!--<plugin path="$NAVIT_PREFIX/lib/libvehicle_file.so" ondemand="no"/>-->
		<!--<xsl:text>&#x0A;        </xsl:text>-->
		<plugin path="$NAVIT_PREFIX/lib/libspeech_android.so" ondemand="no"/>
		<xsl:text>&#x0A;        </xsl:text>
		<xsl:next-match/>
        </xsl:template>
        <xsl:template match="/config/navit/graphics">
                <graphics type="android" />
        </xsl:template>
	<!-- make gui fonts bigger -->
        <xsl:template match="/config/navit/gui[2]">
                <xsl:copy><xsl:copy-of select="@*[not(name()='font_size')]"/>
			<xsl:attribute name="font_size"><xsl:value-of select="$MENU_VALUE_FONTSIZE"/></xsl:attribute>
			<xsl:attribute name="icon_xs"><xsl:value-of select="$MENU_VALUE_ICONS_XS"/></xsl:attribute>
			<xsl:attribute name="icon_s"><xsl:value-of select="$MENU_VALUE_ICONS_S"/></xsl:attribute>
			<xsl:attribute name="icon_l"><xsl:value-of select="$MENU_VALUE_ICONS_L"/></xsl:attribute>
			<xsl:attribute name="spacing"><xsl:value-of select="$MENU_VALUE_SPACING"/></xsl:attribute>
		<xsl:apply-templates/></xsl:copy>
	</xsl:template>
	<!-- make gui fonts bigger -->
	<!-- after map drag jump to position, initial zoom -->
        <xsl:template match="/config/navit[1]">
                <xsl:copy><xsl:copy-of select="@*"/>
			<!--<xsl:attribute name="timeout">0</xsl:attribute>-->
			<xsl:attribute name="zoom">32</xsl:attribute>
		<xsl:apply-templates/></xsl:copy>
	</xsl:template>
	<!-- after map drag jump to position, initial zoom -->
        <xsl:template match="/config/navit/vehicle[1]">
                <xsl:copy><xsl:copy-of select="@*[not(name()='gpsd_query')]"/>
			<xsl:attribute name="source">android:</xsl:attribute>
			<xsl:attribute name="follow">1</xsl:attribute>
		<xsl:apply-templates/></xsl:copy>
	</xsl:template>
	<!-- add new default look-and-feel for android -->
        <xsl:template match="/config/navit/layout[1]">
<layout name="Android-Car" color="#fef9ee" font="Liberation Sans">
		<xsl:text>&#x0A;        </xsl:text>
        <cursor w="50" h="50">
		<xsl:text>&#x0A;        </xsl:text>
        </cursor>
		<xsl:text>&#x0A;        </xsl:text>
		<!-- android layout -->
		<!-- android layout -->
		<!-- android layout -->
			<layer name="polygons001">

				<!-- forest (converted from relations) -->
				<itemgra item_types="poly_wood_from_triang" order="11-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#8ec78d"/>
					<!--<polyline color="#ff0000"/>-->
					<text text_size="8"/>
				</itemgra>
				<itemgra item_types="poly_wood_from_triang" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#8ec78d"/>
					<!--<polyline color="#ff0000"/>-->
					<text text_size="10"/>
				</itemgra>
				<!-- forest (converted from relations) -->


				<itemgra item_types="poly_wood" order="11-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#8ec78d"/>
					<text text_size="8"/>
				</itemgra>
				<itemgra item_types="poly_wood" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#8ec78d"/>
					<text text_size="10"/>
				</itemgra>

				<itemgra item_types="wood_from_relations" order="11-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#478f46"/>
					<!--<polyline color="#ff0000"/>-->
					<text text_size="8"/>
				</itemgra>
				<itemgra item_types="wood_from_relations" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#478f46"/>
					<!--<polyline color="#ff0000"/>-->
					<text text_size="10"/>
				</itemgra>


				<itemgra item_types="poly_park,poly_playground" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#7cc334"/>
					<text text_size="8"/>
				</itemgra>
			</layer>
		<xsl:text>&#x0A;        </xsl:text>

			<layer name="polygons">
				<!-- ocean -->
				<itemgra item_types="poly_water_tiled">
					<polygon color="#82c8ea"/>
				</itemgra>
				<!-- ocean -->

				<!-- waterbodies (converted from relations) -->
				<itemgra item_types="poly_water_from_triang" order="10-{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#82c8ea"/>
					<!--<polyline color="#ff0000"/>-->
					<!--<text text_size="8"/>-->
				</itemgra>
				<itemgra item_types="poly_water_from_triang" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#82c8ea"/>
					<!--<polyline color="#ff0000"/>-->
					<!--<text text_size="10"/>-->
				</itemgra>
				<!-- waterbodies (converted from relations) -->

				<!-- rivers with text -->
				<itemgra item_types="poly_water" order="11-{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#82c8ea"/>
					<polyline color="#5096b8"/>
					<text text_size="8"/>
				</itemgra>
				<itemgra item_types="poly_water" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#82c8ea"/>
					<polyline color="#5096b8"/>
					<text text_size="10"/>
				</itemgra>
				<!-- rivers with text -->

				<!-- rivers with text (converted from relations) -->
				<itemgra item_types="poly_water_from_relations" order="10-{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#82c8ea"/>
					<polyline color="#5096b8"/>
					<text text_size="8"/>
				</itemgra>
				<itemgra item_types="poly_water_from_relations" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#82c8ea"/>
					<polyline color="#5096b8"/>
					<text text_size="10"/>
				</itemgra>
				<!-- rivers with text (converted from relations) -->


				<itemgra item_types="poly_flats,poly_reservoir,poly_zoo,poly_beach,poly_airfield,poly_railway,poly_scrub,poly_military_zone,poly_marine,plantation,tundra" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#a0a0a0"/>
					<text text_size="8"/>
				</itemgra>

				<itemgra item_types="poly_pedestrian" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="13"/>
					<polyline color="#dddddd" width="9"/>
					<polygon color="#dddddd"/>
				</itemgra>
				<itemgra item_types="poly_pedestrian" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="18"/>
					<polyline color="#dddddd" width="14"/>
					<polygon color="#dddddd"/>
				</itemgra>
				<itemgra item_types="poly_pedestrian" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="21"/>
					<polyline color="#dddddd" width="17"/>
					<polygon color="#dddddd"/>
				</itemgra>
				<itemgra item_types="poly_pedestrian" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="25"/>
					<polyline color="#dddddd" width="21"/>
					<polygon color="#dddddd"/>
				</itemgra>
				<itemgra item_types="poly_pedestrian" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#d2d2d2" width="40"/>
					<polyline color="#dddddd" width="34"/>
					<polygon color="#dddddd"/>
				</itemgra>

				<itemgra item_types="poly_plaza" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#dddddd"/>
				</itemgra>

				<itemgra item_types="poly_airport" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#a0a0a0"/>
				</itemgra>

				<!--
				<itemgra item_types="poly_sport,poly_sports_pitch" order="0-">
					<polygon color="#4af04f"/>
				</itemgra>
				<itemgra item_types="poly_industry,poly_place" order="0-">
					<polygon color="#e6e6e6"/>
				</itemgra>
				-->

				<!--
				<itemgra item_types="poly_street_1" order="{round(8-number($LAYOUT_001_ORDER_DELTA_1))}-{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#ffffff"/>
					<polyline color="#d2d2d2" width="1"/>
				</itemgra>
				<itemgra item_types="poly_street_1" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#ffffff"/>
					<polyline color="#d2d2d2" width="2"/>
				</itemgra>
				<itemgra item_types="poly_street_1" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#ffffff"/>
					<polyline color="#d2d2d2" width="3"/>
				</itemgra>
				-->


				<!--
				<itemgra item_types="poly_street_2" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#fefc8c"/>
					<polyline color="#c0c0c0" width="1"/>
				</itemgra>
				<itemgra item_types="poly_street_2" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#fefc8c"/>
					<polyline color="#c0c0c0" width="2"/>
				</itemgra>
				<itemgra item_types="poly_street_2" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#fefc8c"/>
					<polyline color="#c0c0c0" width="3"/>
				</itemgra>
				-->

				<!--
				<itemgra item_types="poly_street_3" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#fefc8c"/>
					<polyline color="#a0a0a0" width="1"/>
				</itemgra>
				<itemgra item_types="poly_street_3" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#fefc8c"/>
					<polyline color="#a0a0a0" width="2"/>
				</itemgra>
				<itemgra item_types="poly_street_3" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polygon color="#fefc8c"/>
					<polyline color="#a0a0a0" width="3"/>
				</itemgra>
				-->



				<!--
				<itemgra item_types="water_line" order="0-">
					<polyline color="#5096b8" width="2"/>
					<text text_size="5"/>
				</itemgra>
				-->

				<!--
				<itemgra item_types="water_river" order="{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#82c8ea" width="1"/>
				</itemgra>
				-->
				<!--
				<itemgra item_types="water_river" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}-{round(7-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#82c8ea" width="3"/>
				</itemgra>
				-->
				<itemgra item_types="water_river" order="{round(8-number($LAYOUT_001_ORDER_DELTA_1))}-{round(9-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#82c8ea" width="4"/>
				</itemgra>
				<itemgra item_types="water_river" order="{round(10-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#82c8ea" width="4"/>
					<text text_size="9"/>
				</itemgra>


				<itemgra item_types="water_canal" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#82c8ea" width="3"/>
					<text text_size="8"/>
				</itemgra>
				<itemgra item_types="water_stream" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#82c8ea" width="2"/>
					<text text_size="8"/>
				</itemgra>
				<itemgra item_types="water_drain" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#82c8ea" width="1"/>
					<text text_size="8"/>
				</itemgra>


				<itemgra item_types="poly_apron" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#d0d0d0"/>
				</itemgra>
				<itemgra item_types="poly_terminal" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#e3c6a6"/>
				</itemgra>
				<itemgra item_types="poly_car_parking" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#e7cf87"/>
				</itemgra>

				<!-- buildings from mutlipolygons -->
				<itemgra item_types="poly_building_from_triang" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#b6a6a6"/>
				</itemgra>
				<!-- buildings from mutlipolygons -->
				<!-- buildings -->
				<itemgra item_types="poly_building" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#b6a6a6"/>
					<polyline color="#dddddd" width="1"/>
				</itemgra>
				<itemgra item_types="poly_university" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#b6a6a6"/>
					<polyline color="#dddddd" width="1"/>
				</itemgra>
				<itemgra item_types="poly_college" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polygon color="#b6a6a6"/>
					<polyline color="#dddddd" width="1"/>
				</itemgra>
				<!-- buildings -->

			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="Borders">
				<!-- prerendered tiles -->
				<itemgra item_types="maptile" order="0-"><maptile/></itemgra>
				<!-- prerendered tiles -->

				<itemgra item_types="border_country" order="0-1">
					<polyline color="#9b1199" width="1" />
				</itemgra>
				<itemgra item_types="border_country" order="2-{round(3-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#9b1199" width="2" />
				</itemgra>
				<itemgra item_types="border_country" order="{round(4-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#9b1199" width="4" />
				</itemgra>
				<itemgra item_types="border_country" order="{round(5-number($LAYOUT_001_ORDER_DELTA_1))}-{round(7-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#9b1199" width="12" />
				</itemgra>
				<itemgra item_types="border_country" order="{round(8-number($LAYOUT_001_ORDER_DELTA_1))}-{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#9b1199" width="20" />
					<!--<polyline color="#9b1199" width="20" dash="2"/>-->
				</itemgra>
				<itemgra item_types="border_country" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#9b1199" width="30" />
					<!--<polyline color="#9b1199" width="30" dash="2"/>-->
				</itemgra>
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="route_001" active="0">
				<!-- route -->
				<itemgra item_types="street_route" order="0-{round(1-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="3"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="8"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="10"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="12"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="16"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="20"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="28"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="32"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="52"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="64"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="68"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="132"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="268"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="530"/>
				</itemgra>



				<itemgra item_types="street_route_waypoint" order="0-{round(1-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="3"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="8"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="10"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="12"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="16"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="20"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="28"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="32"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="52"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="64"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="68"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="132"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="268"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#69e068" width="530"/>
				</itemgra>



				<!-- route -->
			</layer>

		<xsl:text>&#x0A;        </xsl:text>


			<layer name="streets_STR_ONLY" active="0">
				<itemgra item_types="selected_line" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="4"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="8"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="10"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="16"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="20"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="28"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="32"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="52"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="64"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="68"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="132"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="268"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="530"/>
				</itemgra>

			</layer>

			<xsl:text>&#x0A;        </xsl:text>
 
			<layer name="streets">
				<itemgra item_types="selected_line" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="4"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="8"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="10"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="16"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="20"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="28"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="32"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="52"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="64"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="68"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="132"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="268"/>
				</itemgra>
				<itemgra item_types="selected_line" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ba00b8" width="530"/>
				</itemgra>


				<!-- also "car ferry" -->
				<!--
				<itemgra item_types="ferry" order="{round(4-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#574ac9" width="1" dash="3"/>
				</itemgra>
				-->
				<itemgra item_types="ferry" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(9-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#4f4f4f" width="1" dash="3"/>
				</itemgra>
				<itemgra item_types="ferry" order="{round(10-number($LAYOUT_001_ORDER_DELTA_1))}-{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#574ac966" width="6" dash="3"/><!-- color alpha 66 -->
					<text text_size="7"/>
				</itemgra>
				<itemgra item_types="ferry" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#574ac966" width="12" dash="3"/><!-- color alpha 66 -->
					<text text_size="12"/>
				</itemgra>
				<itemgra item_types="ferry" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#574ac966" width="20" dash="3"/><!-- color alpha 66 -->
					<text text_size="20"/>
				</itemgra>
				<!-- also "car ferry" -->
			</layer>

			<xsl:text>&#x0A;        </xsl:text>

			<layer name="streets_1_STR_ONLY" active="0">

				<itemgra item_types="forest_way_1" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#0070c0" width="6"/>
				</itemgra>
				<itemgra item_types="forest_way_2" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ff0000" width="3"/>
				</itemgra>
				<itemgra item_types="forest_way_3" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ff0000" width="1" dash="4"/>
				</itemgra>
				<itemgra item_types="forest_way_4" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#119a2e" width="1" dash="4"/>
				</itemgra>
				<itemgra item_types="street_nopass" order="12-">
					<polyline color="#000000" width="1"/>
				</itemgra>
				<itemgra item_types="track_paved" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#000000" width="1"/>
				</itemgra>
				<itemgra item_types="track_gravelled" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="4"/>
					<polyline color="#800000" width="2" dash="5"/>
				</itemgra>
				<itemgra item_types="track_gravelled" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="5"/>
					<polyline color="#800000" width="3" dash="5"/>
				</itemgra>
				<itemgra item_types="track_gravelled" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ffffff" width="7"/>
					<polyline color="#800000" width="5" dash="5"/>
				</itemgra>
				<itemgra item_types="track_unpaved" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#000000" width="1"/>
				</itemgra>
				<itemgra item_types="bridleway" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#000000" width="1"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<itemgra item_types="footway" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="5"/>
					<polyline color="#ff0000" width="3" dash="6"/>
				</itemgra>
				<itemgra item_types="footway" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ffffff" width="7"/>
					<polyline color="#ff0000" width="5" dash="6"/>
				</itemgra>


				<itemgra item_types="path" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="5"/>
					<polyline color="#660000" width="3" dash="6"/>
				</itemgra>
				<itemgra item_types="path" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ffffff" width="7"/>
					<polyline color="#660000" width="5" dash="6"/>
				</itemgra>

				<itemgra item_types="steps" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="11"/>
					<polyline color="#000000" width="8"/>
					<polyline color="#ff0000" width="5" dash="7"/>
				</itemgra>
				<itemgra item_types="steps" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ffffff" width="13"/>
					<polyline color="#000000" width="10"/>
					<polyline color="#ff0000" width="7" dash="7"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<itemgra item_types="street_pedestrian,living_street" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="13"/>
					<polyline color="#dddddd" width="9"/>
				</itemgra>
				<itemgra item_types="street_pedestrian,living_street" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="18"/>
					<polyline color="#dddddd" width="14"/>
				</itemgra>
				<itemgra item_types="street_pedestrian,living_street" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="21"/>
					<polyline color="#dddddd" width="17"/>
				</itemgra>
				<itemgra item_types="street_pedestrian,living_street" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="25"/>
					<polyline color="#dddddd" width="21"/>
				</itemgra>
				<itemgra item_types="street_pedestrian,living_street" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="40"/>
					<polyline color="#dddddd" width="34"/>
				</itemgra>

				<itemgra item_types="street_service" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="7"/>
					<polyline color="#fefefe" width="5"/>
				</itemgra>
				<itemgra item_types="street_service" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="8"/>
					<polyline color="#fefefe" width="6"/>
				</itemgra>
				<itemgra item_types="street_service" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="9"/>
					<polyline color="#fefefe" width="7"/>
				</itemgra>
				<itemgra item_types="street_service" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="10"/>
					<polyline color="#fefefe" width="8"/>
				</itemgra>
				<itemgra item_types="street_service" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="11"/>
					<polyline color="#fefefe" width="9"/>
				</itemgra>

				<itemgra item_types="street_parking_lane" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="6"/>
					<polyline color="#fefefe" width="4"/>
				</itemgra>
				<itemgra item_types="street_parking_lane" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="7"/>
					<polyline color="#fefefe" width="5"/>
				</itemgra>
				<itemgra item_types="street_parking_lane" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="7"/>
					<polyline color="#fefefe" width="5"/>
				</itemgra>
				<itemgra item_types="street_parking_lane" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="8"/>
					<polyline color="#fefefe" width="6"/>
				</itemgra>
				<itemgra item_types="street_parking_lane" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="9"/>
					<polyline color="#fefefe" width="7"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<!-- very small "white" street -->
				<itemgra item_types="street_0,street_1_city,street_1_land" order="12">
					<polyline color="#d2d2d2" width="1"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="17"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="13"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="18"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="14"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="30"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="26"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="67"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="61"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="132"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="126"/>
				</itemgra>


				<!-- small -->
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="12">
					<polyline color="#c0c0c0" width="1"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="13"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="11"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="19"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="15"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="30"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="26"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="63"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="57"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="100"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="90"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<!-- little bigger -->
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="11">
					<polyline color="#e0e0e0" width="2"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="12">
					<polyline color="#a0a0a0" width="9"/>
					<polyline color="#fefc8c" width="7"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="21"/>
					<polyline color="#fefc8c" width="17"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="25"/>
					<polyline color="#fefc8c" width="21"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="40"/>
					<polyline color="#fefc8c" width="34"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="79"/>
					<polyline color="#fefc8c" width="73"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="156"/>
					<polyline color="#fefc8c" width="150"/>
				</itemgra>

				<itemgra item_types="cycleway" order="14-15">
					<polyline color="#0000ff" width="2" dash="6"/>
				</itemgra>
				<itemgra item_types="cycleway" order="16">
					<polyline color="#ffffff" width="5"/>
					<polyline color="#0000ff" width="3" dash="6"/>
				</itemgra>
				<itemgra item_types="cycleway" order="17-">
					<polyline color="#ffffff" width="7"/>
					<polyline color="#0000ff" width="5" dash="6"/>
				</itemgra>


				<!-- big -->
				<!--
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}-{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#f8dc79" width="4"/>
				</itemgra>
				-->
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="8-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<!--<polyline color="#404040" width="3"/>-->
					<polyline color="#f8dc79" width="4"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}">
					<!--<polyline color="#000000" width="5"/>-->
					<polyline color="#f8dc79" width="5"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<!--<polyline color="#000000" width="6"/>-->
					<polyline color="#f8dc79" width="6"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="9"/>
					<polyline color="#f8dc79" width="7"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="13"/>
					<polyline color="#f8dc79" width="9"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="18"/>
					<polyline color="#f8dc79" width="14"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="21"/>
					<polyline color="#f8dc79" width="17"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="24"/>
					<polyline color="#f8dc79" width="20"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="39"/>
					<polyline color="#f8dc79" width="33"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="78"/>
					<polyline color="#f8dc79" width="72"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="156"/>
					<polyline color="#f8dc79" width="150"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>


				<!-- autobahn / highway -->
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="0-{round(1-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="1"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="3"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="6"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="6"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="6"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="7"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="9"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="13"/>
					<polyline color="#fc843b" width="9"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="15"/>
					<polyline color="#fc843b" width="10"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="25"/>
					<polyline color="#fc843b" width="17"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="31"/>
					<polyline color="#fc843b" width="24"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="33"/>
					<polyline color="#fc843b" width="27"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="65"/>
					<polyline color="#fc843b" width="59"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="133"/>
					<polyline color="#fc843b" width="127"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="264"/>
					<polyline color="#fc843b" width="258"/>
				</itemgra>
			</layer>

		<xsl:text>&#x0A;        </xsl:text>


			<layer name="streets_1">

				<itemgra item_types="rail" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#696969" width="3"/>
					<polyline color="#ffffff" width="1" dash="1"/>
				</itemgra>
				<itemgra item_types="rail" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#696969" width="10"/>
					<polyline color="#ffffff" width="8" dash="1"/>
				</itemgra>
				<itemgra item_types="rail" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#696969" width="20"/>
					<polyline color="#ffffff" width="18" dash="1"/>
				</itemgra>

				<itemgra item_types="rail_narrow_gauge" order="13">
					<polyline color="#696969" width="4"/>
					<polyline color="#FFFFFF" width="2"/>
				</itemgra>
				<itemgra item_types="rail_narrow_gauge" order="14-">
					<polyline color="#696969" width="6"/>
					<polyline color="#FFFFFF" width="4"/>
				</itemgra>

				<itemgra item_types="rail_light" order="13">
					<polyline color="#696969" width="4"/>
					<polyline color="#FFFFFF" width="2"/>
				</itemgra>
				<itemgra item_types="rail_light" order="14-">
					<polyline color="#696969" width="6"/>
					<polyline color="#FFFFFF" width="4"/>
				</itemgra>

				<itemgra item_types="rail_subway" order="10-12">
					<polyline color="#696969" width="3"/>
				</itemgra>
				<itemgra item_types="rail_subway" order="13-14">
					<polyline color="#696969" width="4"/>
					<polyline color="#FFFFFF" width="2"/>
				</itemgra>
				<itemgra item_types="rail_subway" order="15-">
					<polyline color="#696969" width="10"/>
					<polyline color="#FFFFFF" width="8"/>
				</itemgra>

				<itemgra item_types="rail_mono" order="13-">
					<polyline color="#696969" width="1"/>
				</itemgra>
				<itemgra item_types="rail_preserved" order="13-">
					<polyline color="#696969" width="1"/>
				</itemgra>
				<itemgra item_types="rail_disused" order="13-">
					<polyline color="#d3d3d3" width="1"/>
				</itemgra>
				<itemgra item_types="rail_abandoned" order="13-">
					<polyline color="#f5f5f5" width="1"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<itemgra item_types="forest_way_1" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#0070c0" width="6"/>
				</itemgra>
				<itemgra item_types="forest_way_2" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ff0000" width="3"/>
				</itemgra>
				<itemgra item_types="forest_way_3" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ff0000" width="1" dash="4"/>
				</itemgra>
				<itemgra item_types="forest_way_4" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#119a2e" width="1" dash="4"/>
				</itemgra>
				<itemgra item_types="street_nopass" order="12-">
					<polyline color="#000000" width="1"/>
				</itemgra>
				<itemgra item_types="track_paved" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#000000" width="1"/>
				</itemgra>
				<itemgra item_types="track_gravelled" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="4"/>
					<polyline color="#800000" width="2" dash="5"/>
				</itemgra>
				<itemgra item_types="track_gravelled" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="5"/>
					<polyline color="#800000" width="3" dash="5"/>
				</itemgra>
				<itemgra item_types="track_gravelled" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ffffff" width="7"/>
					<polyline color="#800000" width="5" dash="5"/>
				</itemgra>
				<itemgra item_types="track_unpaved" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#000000" width="1"/>
				</itemgra>
				<itemgra item_types="bridleway" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#000000" width="1"/>
				</itemgra>


				<itemgra item_types="lift_cable_car" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#696969" width="1" dash="5"/>
				</itemgra>
				<itemgra item_types="lift_chair" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#696969" width="1" dash="5"/>
				</itemgra>
				<itemgra item_types="lift_drag" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#696969" width="1" dash="5"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<itemgra item_types="footway" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="5"/>
					<polyline color="#ff0000" width="3" dash="6"/>
				</itemgra>
				<itemgra item_types="footway" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ffffff" width="7"/>
					<polyline color="#ff0000" width="5" dash="6"/>
				</itemgra>


				<itemgra item_types="path" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="5"/>
					<polyline color="#660000" width="3" dash="6"/>
				</itemgra>
				<itemgra item_types="path" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ffffff" width="7"/>
					<polyline color="#660000" width="5" dash="6"/>
				</itemgra>

				<itemgra item_types="steps" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#ffffff" width="11"/>
					<polyline color="#000000" width="8"/>
					<polyline color="#ff0000" width="5" dash="7"/>
				</itemgra>
				<itemgra item_types="steps" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#ffffff" width="13"/>
					<polyline color="#000000" width="10"/>
					<polyline color="#ff0000" width="7" dash="7"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<itemgra item_types="street_pedestrian,living_street" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="13"/>
					<polyline color="#dddddd" width="9"/>
				</itemgra>
				<itemgra item_types="street_pedestrian,living_street" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="18"/>
					<polyline color="#dddddd" width="14"/>
				</itemgra>
				<itemgra item_types="street_pedestrian,living_street" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="21"/>
					<polyline color="#dddddd" width="17"/>
				</itemgra>
				<itemgra item_types="street_pedestrian,living_street" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="25"/>
					<polyline color="#dddddd" width="21"/>
				</itemgra>
				<itemgra item_types="street_pedestrian,living_street" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="40"/>
					<polyline color="#dddddd" width="34"/>
				</itemgra>

				<itemgra item_types="street_service" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="7"/>
					<polyline color="#fefefe" width="5"/>
				</itemgra>
				<itemgra item_types="street_service" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="8"/>
					<polyline color="#fefefe" width="6"/>
				</itemgra>
				<itemgra item_types="street_service" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="9"/>
					<polyline color="#fefefe" width="7"/>
				</itemgra>
				<itemgra item_types="street_service" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="10"/>
					<polyline color="#fefefe" width="8"/>
				</itemgra>
				<itemgra item_types="street_service" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="11"/>
					<polyline color="#fefefe" width="9"/>
				</itemgra>

				<itemgra item_types="street_parking_lane" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="6"/>
					<polyline color="#fefefe" width="4"/>
				</itemgra>
				<itemgra item_types="street_parking_lane" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="7"/>
					<polyline color="#fefefe" width="5"/>
				</itemgra>
				<itemgra item_types="street_parking_lane" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="7"/>
					<polyline color="#fefefe" width="5"/>
				</itemgra>
				<itemgra item_types="street_parking_lane" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="8"/>
					<polyline color="#fefefe" width="6"/>
				</itemgra>
				<itemgra item_types="street_parking_lane" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="9"/>
					<polyline color="#fefefe" width="7"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<!-- very small "white" street -->
				<itemgra item_types="street_0,street_1_city,street_1_land" order="12">
					<polyline color="#d2d2d2" width="1"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="17"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="13"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="18"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="14"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="30"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="26"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="67"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="61"/>
				</itemgra>
				<itemgra item_types="street_0,street_1_city,street_1_land" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#d2d2d2" width="132"/>
					<polyline color="#ffffff" nightcol="#bdbdbd" width="126"/>
				</itemgra>


				<!-- small -->
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="12">
					<polyline color="#c0c0c0" width="1"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="13"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="11"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="19"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="15"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="30"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="26"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="63"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="57"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,ramp" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#c0c0c0" width="100"/>
					<polyline color="#fefc8c" nightcol="#bdbdbd" width="90"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<!-- little bigger -->
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="11">
					<polyline color="#e0e0e0" width="2"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="12">
					<polyline color="#a0a0a0" width="9"/>
					<polyline color="#fefc8c" width="7"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="13-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="21"/>
					<polyline color="#fefc8c" width="17"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="25"/>
					<polyline color="#fefc8c" width="21"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="40"/>
					<polyline color="#fefc8c" width="34"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="79"/>
					<polyline color="#fefc8c" width="73"/>
				</itemgra>
				<itemgra item_types="street_3_city,ramp_street_3_city,street_3_land,roundabout" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a0a0a0" width="156"/>
					<polyline color="#fefc8c" width="150"/>
				</itemgra>

				<itemgra item_types="cycleway" order="14-15">
					<polyline color="#0000ff" width="2" dash="6"/>
				</itemgra>
				<itemgra item_types="cycleway" order="16">
					<polyline color="#ffffff" width="5"/>
					<polyline color="#0000ff" width="3" dash="6"/>
				</itemgra>
				<itemgra item_types="cycleway" order="17-">
					<polyline color="#ffffff" width="7"/>
					<polyline color="#0000ff" width="5" dash="6"/>
				</itemgra>


				<!-- big -->
				<!--
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}-{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#f8dc79" width="4"/>
				</itemgra>
				-->
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="8-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<!--<polyline color="#404040" width="3"/>-->
					<polyline color="#f8dc79" width="4"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}">
					<!--<polyline color="#000000" width="5"/>-->
					<polyline color="#f8dc79" width="5"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<!--<polyline color="#000000" width="6"/>-->
					<polyline color="#f8dc79" width="6"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="9"/>
					<polyline color="#f8dc79" width="7"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="13"/>
					<polyline color="#f8dc79" width="9"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="18"/>
					<polyline color="#f8dc79" width="14"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="21"/>
					<polyline color="#f8dc79" width="17"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="24"/>
					<polyline color="#f8dc79" width="20"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="39"/>
					<polyline color="#f8dc79" width="33"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="78"/>
					<polyline color="#f8dc79" width="72"/>
				</itemgra>
				<itemgra item_types="street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#000000" width="156"/>
					<polyline color="#f8dc79" width="150"/>
				</itemgra>

				<xsl:text>&#x0A;        </xsl:text>

				<itemgra item_types="bus_guideway" order="13-">
					<polyline color="#696969" width="1"/>
				</itemgra>
				<itemgra item_types="rail_tram" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#606060" width="1"/>
				</itemgra>
				<itemgra item_types="rail_tram" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#606060" width="2"/>
				</itemgra>


				<!-- autobahn / highway -->
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="0-{round(1-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="1"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="3"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="6"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="6"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="6"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="7"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#fc843b" width="9"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="13"/>
					<polyline color="#fc843b" width="9"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="15"/>
					<polyline color="#fc843b" width="10"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="25"/>
					<polyline color="#fc843b" width="17"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="31"/>
					<polyline color="#fc843b" width="24"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="33"/>
					<polyline color="#fc843b" width="27"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="65"/>
					<polyline color="#fc843b" width="59"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="133"/>
					<polyline color="#fc843b" width="127"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#a8aab3" width="264"/>
					<polyline color="#fc843b" width="258"/>
				</itemgra>
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="route_002" active="0"> <!-- DEFAULT style for ROUTE -->
				<!-- route -->
				<itemgra item_types="street_route" order="0-{round(1-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="2"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="8"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="8"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="10"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="12"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="20"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="38"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="46"/>
				</itemgra>

				<itemgra item_types="street_route_waypoint" order="0-{round(1-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="2"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="8"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="8"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="10"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="12"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="20"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="38"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="46"/>
				</itemgra>

				<!-- route -->
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="streets_2_STR_ONLY" active="0">

				<!-- traffic distortion -->
				<itemgra item_types="traffic_distortion" order="{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="8"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="10"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="14"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="16"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="26"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="32" dash="3"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="34" dash="3"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="66" dash="3"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="134" dash="3"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="265" dash="3"/>
				</itemgra>
				<!-- traffic distortion -->

				<xsl:text>&#x0A;        </xsl:text>


				<itemgra item_types="highway_exit_label" order="12-">
					<circle color="#000000" radius="3" text_size="7"/>
				</itemgra>

				<!-- text size for streetnames -->
				<itemgra item_types="highway_city,highway_land,ramp_highway_land,street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="7"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land,street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="9"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land,street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="13"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land,street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="28"/>
				</itemgra>

		<xsl:text>&#x0A;        </xsl:text>


				<!--
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,street_3_city,ramp_street_3_city,street_3_land,ramp" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="7"/>
				</itemgra>
				-->
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,street_3_city,ramp_street_3_city,street_3_land,ramp" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="9"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,street_3_city,ramp_street_3_city,street_3_land,ramp" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="13"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,street_3_city,ramp_street_3_city,street_3_land,ramp" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="28"/>
				</itemgra>

				<!--
				<itemgra item_types="street_1_city,street_1_land" order="13">
					<text text_size="7"/>
				</itemgra>
				-->

				<itemgra item_types="street_nopass,street_0,street_1_city,street_1_land" order="12-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="9"/>
				</itemgra>
				<itemgra item_types="street_nopass,street_0,street_1_city,street_1_land" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="13"/>
				</itemgra>
				<itemgra item_types="street_nopass,street_0,street_1_city,street_1_land" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="28"/>
				</itemgra>
				<!-- text size for streetnames -->

			</layer>

			<layer name="streets_2">

				<!-- traffic distortion -->
				<itemgra item_types="traffic_distortion" order="{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="8"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="10"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="14"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="16"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc0000" width="26"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="32" dash="3"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="34" dash="3"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="66" dash="3"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="134" dash="3"/>
				</itemgra>
				<itemgra item_types="traffic_distortion" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#cc000066" width="265" dash="3"/>
				</itemgra>
				<!-- traffic distortion -->

				<xsl:text>&#x0A;        </xsl:text>


				<itemgra item_types="highway_exit_label" order="12-">
					<circle color="#000000" radius="3" text_size="7"/>
				</itemgra>

				<!-- text size for streetnames -->
				<itemgra item_types="highway_city,highway_land,ramp_highway_land,street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="7"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land,street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="9"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land,street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="13"/>
				</itemgra>
				<itemgra item_types="highway_city,highway_land,ramp_highway_land,street_4_city,ramp_street_4_city,street_4_land,street_n_lanes" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="28"/>
				</itemgra>

		<xsl:text>&#x0A;        </xsl:text>


				<!--
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,street_3_city,ramp_street_3_city,street_3_land,ramp" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="7"/>
				</itemgra>
				-->
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,street_3_city,ramp_street_3_city,street_3_land,ramp" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="9"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,street_3_city,ramp_street_3_city,street_3_land,ramp" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="13"/>
				</itemgra>
				<itemgra item_types="street_2_city,ramp_street_2_city,street_2_land,street_3_city,ramp_street_3_city,street_3_land,ramp" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="28"/>
				</itemgra>

				<!--
				<itemgra item_types="street_1_city,street_1_land" order="13">
					<text text_size="7"/>
				</itemgra>
				-->


				<itemgra item_types="rail_tram" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<text text_size="10"/>
				</itemgra>
				<itemgra item_types="rail" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<text text_size="10"/>
				</itemgra>
				<itemgra item_types="rail_subway" order="13-">
					<text text_size="9"/>
				</itemgra>


				<itemgra item_types="street_nopass,street_0,street_1_city,street_1_land" order="12-{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="9"/>
				</itemgra>
				<itemgra item_types="street_nopass,street_0,street_1_city,street_1_land" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="13"/>
				</itemgra>
				<itemgra item_types="street_nopass,street_0,street_1_city,street_1_land" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}-{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<text text_size="28"/>
				</itemgra>
				<!-- text size for streetnames -->

			</layer>

		<xsl:text>&#x0A;        </xsl:text>


		<xsl:text>&#x0A;        </xsl:text>

			<!--
			<layer name="polylines">
			</layer>
			-->

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="labels">
				<!-- house numbers -->
				<itemgra item_types="house_number" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
						<circle color="#000000" radius="3" text_size="7"/>
				</itemgra>
				<itemgra item_types="house_number" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}-">
						<circle color="#000000" radius="3" text_size="14"/>
				</itemgra>
				<!-- house numbers -->




				<!-- city/town labels -->

				<!-- very large cities first -->
				<itemgra item_types="district_label_5e6,district_label_1e7" order="7-9">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>
				<itemgra item_types="district_label_5e6,district_label_1e7" order="10-">
					<circle color="#000000" radius="3" text_size="15"/>
				</itemgra>
				<itemgra item_types="district_label_1e6,district_label_2e6" order="8-">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>

				<itemgra item_types="town_label_1e5,town_label_2e5,town_label_5e5" order="3-{round(4-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>
				<itemgra item_types="town_label_1e5,town_label_2e5,town_label_5e5" order="{round(5-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#000000" radius="3" text_size="15"/>
				</itemgra>
				<itemgra item_types="town_label_1e4" order="7-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>
				<itemgra item_types="town_label_2e4,town_label_5e4" order="7-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>
				<itemgra item_types="town_label_5e3,town_label_1e4,town_label_2e4,town_label_5e4" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#000000" radius="3" text_size="15"/>
				</itemgra>
				<itemgra item_types="town_label_5e3" order="7-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>
				<itemgra item_types="town_label_2e3" order="{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#000000" radius="3" text_size="7"/>
				</itemgra>
				<itemgra item_types="town_label_2e3" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>

				<itemgra item_types="district_label_1e5,district_label_2e5,district_label_5e5" order="9-">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>
				<itemgra item_types="district_label_1e4,district_label_2e4,district_label_5e4" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#000000" radius="3" text_size="8"/>
				</itemgra>
				<itemgra item_types="district_label_1e3,district_label_2e3,district_label_5e3" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#000000" radius="3" text_size="8"/>
				</itemgra>

				<itemgra item_types="town_label_1e3,place_label" order="10-">
					<circle color="#000000" radius="3" text_size="10"/>
				</itemgra>

				<itemgra item_types="town_label_1e2,town_label_2e2,town_label_5e2,district_label_5e1,district_label_1e2,district_label_2e2,district_label_5e2" order="11-">
					<circle color="#000000" radius="3" text_size="7"/>
				</itemgra>

				<itemgra item_types="district_label,town_label" order="9-">
					<circle color="#000000" radius="3" text_size="7"/>
				</itemgra>
				<itemgra item_types="town_label_0e0,town_label_1e0,town_label_2e0,town_label_5e0,town_label_1e1,town_label_2e1,town_label_5e1,district_label_0e0,district_label_1e0,district_label_2e0,district_label_5e0,district_label_1e1,district_label_2e1" order="11-">
					<circle color="#000000" radius="3" text_size="7"/>
				</itemgra>

				<!-- less large cities later -->




				<!-- "radius" means actually "diameter" on the android version!! -->
				<itemgra item_types="town_label_1e7" order="0-{round(3-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#ffffff" radius="25" width="12"/>
					<circle color="#000000" radius="20" width="10" text_size="10"/>
				</itemgra>
				<itemgra item_types="town_label_1e7" order="{round(4-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#ffffff" radius="25" width="12"/>
					<circle color="#000000" radius="20" width="10" text_size="15"/>
				</itemgra>
				<itemgra item_types="town_label_1e7" order="{round(5-number($LAYOUT_001_ORDER_DELTA_1))}-6">
					<circle color="#ffffff" radius="25" width="12"/>
					<circle color="#000000" radius="20" width="10" text_size="20"/>
				</itemgra>
				<itemgra item_types="town_label_1e7" order="7-">
					<circle color="#ffffff" radius="8" width="4"/>
					<circle color="#000000" radius="4" width="2" text_size="20"/>
				</itemgra>

				<itemgra item_types="town_label_5e6" order="0-{round(3-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#ffffff" radius="25" width="12"/>
					<circle color="#000000" radius="20" width="10" text_size="9"/>
				</itemgra>
				<itemgra item_types="town_label_5e6" order="{round(4-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#ffffff" radius="25" width="12"/>
					<circle color="#000000" radius="20" width="10" text_size="14"/>
				</itemgra>
				<itemgra item_types="town_label_5e6" order="{round(5-number($LAYOUT_001_ORDER_DELTA_1))}-6">
					<circle color="#ffffff" radius="25" width="12"/>
					<circle color="#000000" radius="20" width="10" text_size="19"/>
				</itemgra>
				<itemgra item_types="town_label_5e6" order="7-">
					<circle color="#ffffff" radius="8" width="4"/>
					<circle color="#000000" radius="4" width="2" text_size="19"/>
				</itemgra>

				<itemgra item_types="town_label_2e6" order="0-{round(3-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#ffffff" radius="20" width="10"/>
					<circle color="#000000" radius="15" width="9" text_size="9"/>
				</itemgra>
				<itemgra item_types="town_label_2e6" order="{round(4-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#ffffff" radius="20" width="10"/>
					<circle color="#000000" radius="15" width="9" text_size="14"/>
				</itemgra>
				<itemgra item_types="town_label_2e6" order="{round(5-number($LAYOUT_001_ORDER_DELTA_1))}-6">
					<circle color="#ffffff" radius="20" width="10"/>
					<circle color="#000000" radius="15" width="9" text_size="19"/>
				</itemgra>
				<itemgra item_types="town_label_2e6" order="7-">
					<circle color="#ffffff" radius="8" width="4"/>
					<circle color="#000000" radius="4" width="2" text_size="19"/>
				</itemgra>

				<itemgra item_types="town_label_1e6" order="0-{round(3-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#ffffff" radius="20" width="10"/>
					<circle color="#000000" radius="15" width="9" text_size="9"/>
				</itemgra>
				<itemgra item_types="town_label_1e6" order="{round(4-number($LAYOUT_001_ORDER_DELTA_1))}">
					<circle color="#ffffff" radius="20" width="10"/>
					<circle color="#000000" radius="15" width="9" text_size="14"/>
				</itemgra>
				<itemgra item_types="town_label_1e6" order="{round(5-number($LAYOUT_001_ORDER_DELTA_1))}-6">
					<circle color="#ffffff" radius="20" width="10"/>
					<circle color="#000000" radius="15" width="9" text_size="19"/>
				</itemgra>
				<itemgra item_types="town_label_1e6" order="7-">
					<circle color="#ffffff" radius="8" width="4"/>
					<circle color="#000000" radius="4" width="2" text_size="19"/>
				</itemgra>


				<!-- city/town labels -->

			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="GPXdata" active="1">
				<!-- GPX waypoint -->
				<itemgra item_types="gpx_point" order="3-11">
					<circle color="#0202ff" radius="14" width="4"/>
				</itemgra>
				<itemgra item_types="gpx_point" order="8-11">
					<circle color="#0e0e0e" radius="0" width="0" text_size="8"/>
				</itemgra>

				<itemgra item_types="gpx_point" order="12-">
					<circle color="#0202ff" radius="20" width="6"/>
				</itemgra>
				<itemgra item_types="gpx_point" order="12-">
					<circle color="#0e0e0e" radius="0" width="0" text_size="18"/>
				</itemgra>
				<!-- GPX waypoint -->

				<!-- GPX track -->
				<itemgra item_types="gpx_track" order="3-11">
					<polyline color="#ae101066" width="4"/><!-- alpha 0x66-->
					<text text_size="10"/>
				</itemgra>
				<itemgra item_types="gpx_track" order="12-">
					<polyline color="#ae101066" width="10"/><!-- alpha 0x66-->
					<text text_size="14"/>
				</itemgra>
				<!-- GPX track -->

				<!-- GPX route -->
				<itemgra item_types="gpx_route" order="3-11">
					<polyline color="#1010ae66" width="4"/><!-- alpha 0x66-->
					<text text_size="10"/>
				</itemgra>
				<itemgra item_types="gpx_route" order="12-">
					<polyline color="#1010ae66" width="10"/><!-- alpha 0x66-->
					<text text_size="14"/>
				</itemgra>
				<!-- GPX route -->
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="route_003" active="0">
				<!-- route -->
				<itemgra item_types="street_route" order="0-{round(1-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="2"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="8"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="8"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="12"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="16"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="24"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="40"/>
				</itemgra>
				<itemgra item_types="street_route" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="46"/>
				</itemgra>



				<itemgra item_types="street_route_waypoint" order="0-{round(1-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="2"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(2-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(3-number($LAYOUT_001_ORDER_DELTA_1))}-{round(5-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(6-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="4"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-{round(8-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(9-number($LAYOUT_001_ORDER_DELTA_1))}-{round(10-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(11-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fe" width="6"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="8"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="8"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="12"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="16"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(16-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="24"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(17-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="40"/>
				</itemgra>
				<itemgra item_types="street_route_waypoint" order="{round(18-number($LAYOUT_001_ORDER_DELTA_1))}">
					<polyline color="#0000fee0" width="46"/>
				</itemgra>

				<!-- route -->
			</layer>


		<xsl:text>&#x0A;        </xsl:text>


			<layer name="Internal">
				<itemgra item_types="track" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#3f3f3f" width="1"/>
				</itemgra>
				<itemgra item_types="track_tracked" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<polyline color="#3f3fff" width="3"/>
				</itemgra>
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="POI Symbols" active="1">
				<itemgra item_types="mini_roundabout" order="14-">
					<icon src="mini_roundabout.png"/>
				</itemgra>
				<itemgra item_types="turning_circle" order="14-">
					<icon src="mini_roundabout.png"/>
				</itemgra>
				<itemgra item_types="poi_airport" order="8-">
					<icon src="poi_airport.png"/>
				</itemgra>
				<itemgra item_types="poi_fuel" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_fuel.png"/>
				</itemgra>
				<!--
				<itemgra item_types="poi_bridge" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_bridge.png"/>
				</itemgra>
				<itemgra item_types="highway_exit" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_exit.png"/>
				</itemgra>
				<itemgra item_types="poi_auto_club" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_auto_club.png"/>
				</itemgra>
				-->
				<itemgra item_types="poi_bank" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_bank.png"/>
				</itemgra>
				<itemgra item_types="poi_atm" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_atm.png"/>
				</itemgra>
				<!--
				<itemgra item_types="poi_danger_area" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_danger_16_16.png"/>
				</itemgra>
				<itemgra item_types="poi_forbidden_area" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_forbiden_area.png"/>
				</itemgra>
				<itemgra item_types="poi_tunnel" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="poi_tunnel.png"/>
				</itemgra>
				-->
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="POI traffic lights" active="0">
				<itemgra item_types="traffic_signals" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="traffic_signals.png"/>
				</itemgra>
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="POI Labels" active="1">
				<itemgra item_types="poi_fuel" order="{round(12-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#606060" radius="0" width="0" text_size="10"/>
				</itemgra>
				<itemgra item_types="poi_bank,poi_atm" order="{round(13-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#606060" radius="0" width="0" text_size="10"/>
				</itemgra>
				<itemgra item_types="poi_airport" order="8-">
					<circle color="#606060" radius="0" width="0" text_size="10"/>
				</itemgra>
				<!--
				<itemgra item_types="poi_airport,town_ghost,poi_hotel,poi_car_parking,poi_car_dealer_parts,poi_fuel,poi_shopping,poi_attraction,poi_cafe,poi_bar,highway_exit,poi_camp_rv,poi_museum_history,poi_hospital,poi_dining,poi_fastfood,poi_police,poi_autoservice,poi_bank,poi_bus_station,poi_bus_stop,poi_business_service,poi_car_rent,poi_church,poi_cinema,poi_concert,poi_drinking_water,poi_emergency,poi_fair,poi_fish,poi_government_building,poi_hotspring,poi_information,poi_justice,poi_landmark,poi_library,poi_mall,poi_manmade_feature,poi_marine,poi_marine_type,poi_mark,poi_oil_field,poi_peak,poi_personal_service,poi_pharmacy,poi_post_office,poi_public_office,poi_rail_halt,poi_rail_station,poi_rail_tram_stop,poi_repair_service,poi_resort,poi_restaurant,poi_restricted_area,poi_sailing,poi_scenic_area,poi_school,poi_service,poi_shop_retail,poi_skiing,poi_social_service,poi_sport,poi_stadium,poi_swimming,poi_theater,poi_townhall,poi_trail,poi_truck_stop,poi_tunnel,poi_worship,poi_wrecker,poi_zoo,poi_biergarten,poi_castle,poi_ruins,poi_memorial,poi_monument,poi_shelter,poi_fountain,poi_viewpoint,vehicle" order="{round(15-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#606060" radius="0" width="0" text_size="10"/>
				</itemgra>
				-->
				<!--
				<itemgra item_types="poi_custom0,poi_custom1,poi_custom2,poi_custom3,poi_custom4,poi_custom5,poi_custom6,poi_custom7,poi_custom8,poi_custom9,poi_customa,poi_customb,poi_customc,poi_customd,poi_custome,poi_customf" order="{round(14-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<circle color="#606060" radius="0" width="0" text_size="10"/>
				</itemgra>
				-->
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="Android-POI-Icons-full" active="0">
				<itemgra item_types="mini_roundabout" order="13-">
					<icon src="mini_roundabout.png"/>
				</itemgra>
				<itemgra item_types="turning_circle" order="12-">
					<icon src="mini_roundabout.png"/>
				</itemgra>
				<itemgra item_types="poi_airport" order="5-">
					<icon src="poi_airport.png"/>
				</itemgra>
				<itemgra item_types="town_ghost" order="11-">
					<icon src="poi_ghost_town.png"/>
				</itemgra>
				<itemgra item_types="poi_hotel" order="12-">
					<icon src="poi_hotel.png"/>
				</itemgra>
				<itemgra item_types="poi_car_parking" order="11-">
					<icon src="poi_parking.png"/>
				</itemgra>
				<itemgra item_types="poi_car_dealer_parts" order="12-">
					<icon src="poi_car_dealer.png"/>
				</itemgra>
				<itemgra item_types="poi_fuel" order="12-">
					<icon src="poi_fuel.png"/>
				</itemgra>
				<itemgra item_types="poi_shopping" order="12-">
					<icon src="poi_shopping.png"/>
				</itemgra>
				<itemgra item_types="poi_attraction" order="11-">
					<icon src="poi_attraction.png"/>
				</itemgra>
				<itemgra item_types="poi_cafe" order="12-">
					<icon src="poi_cafe.png"/>
				</itemgra>
				<itemgra item_types="poi_bar" order="12-">
					<icon src="poi_bar.png"/>
				</itemgra>
<!--
				<itemgra item_types="poi_bridge" order="12-">
					<icon src="poi_bridge.png"/>
				</itemgra>
-->
<!--
				<itemgra item_types="highway_exit" order="11-">
					<icon src="poi_exit.png"/>
				</itemgra>
-->
				<itemgra item_types="poi_camp_rv" order="12-">
					<icon src="poi_camping.png"/>
				</itemgra>
				<itemgra item_types="poi_museum_history" order="12-">
					<icon src="poi_museum.png"/>
				</itemgra>
				<itemgra item_types="poi_hospital" order="12-">
					<icon src="poi_hospital.png"/>
				</itemgra>
				<itemgra item_types="poi_dining" order="12-">
					<icon src="poi_dining.png"/>
				</itemgra>
				<itemgra item_types="poi_fastfood" order="12-">
					<icon src="poi_fastfood.png"/>
				</itemgra>
				<itemgra item_types="poi_police" order="12-">
					<icon src="poi_police.png"/>
				</itemgra>
				<itemgra item_types="poi_auto_club" order="12-">
					<icon src="poi_auto_club.png"/>
				</itemgra>
				<itemgra item_types="poi_autoservice" order="12-">
					<icon src="poi_car_dealer.png"/>
				</itemgra>
				<itemgra item_types="poi_bank" order="12-">
					<icon src="poi_bank.png"/>
				</itemgra>
				<itemgra item_types="poi_atm" order="12-">
					<icon src="poi_atm.png"/>
				</itemgra>
				<itemgra item_types="poi_bay" order="12-">
					<icon src="poi_bay.png"/>
				</itemgra>
				<itemgra item_types="poi_bend" order="12-">
					<icon src="poi_bend.png"/>
				</itemgra>
				<itemgra item_types="poi_boat_ramp" order="12-">
					<icon src="poi_boat_ramp.png"/>
				</itemgra>
				<itemgra item_types="poi_border_station" order="12-">
					<icon src="poi_border_station.png"/>
				</itemgra>
				<itemgra item_types="poi_bowling" order="12-">
					<icon src="poi_bowling.png"/>
				</itemgra>
				<itemgra item_types="poi_bus_station" order="11-">
					<icon src="poi_bus.png"/>
				</itemgra>
				<itemgra item_types="poi_bus_stop" order="12-">
					<icon src="poi_bus.png"/>
				</itemgra>
				<itemgra item_types="poi_business_service" order="12-">
					<icon src="poi_bussines_service.png"/>
				</itemgra>
				<itemgra item_types="poi_car_rent" order="12-">
					<icon src="poi_car_rent.png"/>
				</itemgra>
				<itemgra item_types="poi_car_wash" order="12-">
					<icon src="poi_car_wash.png"/>
				</itemgra>
				<itemgra item_types="poi_casino" order="12-">
					<icon src="poi_casino.png"/>
				</itemgra>
				<itemgra item_types="poi_cemetery" order="12-">
					<icon src="poi_cemetery.png"/>
				</itemgra>
				<itemgra item_types="poi_church" order="11-">
					<icon src="poi_church.png"/>
				</itemgra>
				<itemgra item_types="poi_cinema" order="12-">
					<icon src="poi_cinema.png"/>
				</itemgra>
				<itemgra item_types="poi_communication" order="12-">
					<icon src="poi_communication.png"/>
				</itemgra>
				<itemgra item_types="poi_concert" order="12-">
					<icon src="poi_concert.png"/>
				</itemgra>
				<itemgra item_types="poi_cove" order="12-">
					<icon src="poi_cove.png"/>
				</itemgra>
				<itemgra item_types="poi_crossing" order="12-">
					<icon src="poi_crossing.png"/>
				</itemgra>
				<itemgra item_types="poi_dam" order="12-">
					<icon src="poi_dam.png"/>
				</itemgra>
				<itemgra item_types="poi_danger_area" order="12-">
					<icon src="poi_danger.png"/>
				</itemgra>
				<itemgra item_types="poi_danger_sea_wreck" order="12-">
					<icon src="poi_dangerous.png"/>
				</itemgra>
				<itemgra item_types="poi_daymark" order="12-">
					<icon src="poi_daymark.png"/>
				</itemgra>
				<itemgra item_types="poi_diving" order="12-">
					<icon src="poi_diving.png"/>
				</itemgra>
				<itemgra item_types="poi_drinking_water" order="13-">
					<icon src="poi_drinking_water.png"/>
				</itemgra>
				<itemgra item_types="poi_emergency" order="12-">
					<icon src="poi_emergency.png"/>
				</itemgra>
				<itemgra item_types="poi_fair" order="12-">
					<icon src="poi_fair.png"/>
				</itemgra>
				<itemgra item_types="poi_firebrigade" order="12-">
					<icon src="poi_firebrigade.png"/>
				</itemgra>
				<itemgra item_types="poi_fish" order="10-">
					<icon src="poi_fish.png"/>
				</itemgra>
				<itemgra item_types="poi_forbidden_area" order="12-">
					<icon src="poi_forbiden_area.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_gps" order="15-">
					<icon src="poi_garmin.png"/>
				</itemgra>
				<itemgra item_types="poi_golf" order="12-">
					<icon src="poi_golf.png"/>
				</itemgra>
				<itemgra item_types="poi_government_building" order="12-">
					<icon src="poi_goverment_building.png"/>
				</itemgra>
				<itemgra item_types="poi_height" order="12-">
					<icon src="poi_height.png"/>
				</itemgra>
				<itemgra item_types="poi_heliport" order="10-">
					<icon src="poi_heliport.png"/>
				</itemgra>
				<itemgra item_types="poi_hotspring" order="12-">
					<icon src="poi_hotspring.png"/>
				</itemgra>
				<itemgra item_types="poi_icesport" order="12-">
					<icon src="poi_icesport.png"/>
				</itemgra>
				<itemgra item_types="poi_information" order="12-">
					<icon src="poi_information.png"/>
				</itemgra>
				<itemgra item_types="poi_justice" order="12-">
					<icon src="poi_justice.png"/>
				</itemgra>
				<itemgra item_types="poi_landmark" order="11-">
					<icon src="poi_landmark.png"/>
				</itemgra>
				<itemgra item_types="poi_levee" order="12-">
					<icon src="poi_levee.png"/>
				</itemgra>
				<itemgra item_types="poi_level_crossing" order="13-">
					<icon src="poi_level_crossing.png"/>
				</itemgra>
				<itemgra item_types="poi_library" order="12-">
					<icon src="poi_library.png"/>
				</itemgra>
				<itemgra item_types="poi_locale" order="12-">
					<icon src="poi_locale.png"/>
				</itemgra>
				<itemgra item_types="poi_loudspeaker" order="12-">
					<icon src="poi_loudspeaker.png"/>
				</itemgra>
				<itemgra item_types="poi_mall" order="12-">
					<icon src="poi_mall.png"/>
				</itemgra>
				<itemgra item_types="poi_manmade_feature" order="12-">
					<icon src="poi_manmade_feature.png"/>
				</itemgra>
				<itemgra item_types="poi_marine" order="12-">
					<icon src="poi_marine.png"/>
				</itemgra>
				<itemgra item_types="poi_marine_type" order="12-">
					<icon src="poi_marine_type.png"/>
				</itemgra>
				<itemgra item_types="poi_mark" order="12-">
					<icon src="poi_mark.png"/>
				</itemgra>
				<itemgra item_types="poi_military" order="11-">
					<icon src="poi_military.png"/>
				</itemgra>
				<itemgra item_types="poi_mine" order="12-">
					<icon src="poi_mine.png"/>
				</itemgra>
				<itemgra item_types="poi_nondangerous" order="12-">
					<icon src="poi_nondangerous.png"/>
				</itemgra>
				<itemgra item_types="poi_oil_field" order="12-">
					<icon src="poi_oil_field.png"/>
				</itemgra>
				<itemgra item_types="poi_peak" order="7-">
					<icon src="poi_peak.png"/>
				</itemgra>
				<itemgra item_types="poi_personal_service" order="12-">
					<icon src="poi_personal_service.png"/>
				</itemgra>
				<itemgra item_types="poi_pharmacy" order="12-">
					<icon src="poi_pharmacy.png"/>
				</itemgra>
				<itemgra item_types="poi_post_office,poi_post_box" order="13-">
					<icon src="poi_post.png"/>
				</itemgra>
				<itemgra item_types="poi_public_office" order="12-">
					<icon src="poi_public_office.png"/>
				</itemgra>
				<itemgra item_types="poi_rail_halt" order="12-">
					<circle color="#ff0000" radius="3" width="3"/>
					<circle color="#000000" radius="5" width="2" text_size="8"/>
				</itemgra>
				<itemgra item_types="poi_rail_station" order="12-">
					<circle color="#ff0000" radius="3" width="3"/>
					<circle color="#000000" radius="6" width="2" text_size="8"/>
				</itemgra>
				<itemgra item_types="poi_rail_tram_stop" order="12">
					<circle color="#ff0000" radius="2" width="2"/>
				</itemgra>
				<itemgra item_types="poi_rail_tram_stop" order="12-">
					<circle color="#ff0000" radius="3" width="3"/>
					<circle color="#606060" radius="5" width="2" text_size="8"/>
				</itemgra>
				<itemgra item_types="poi_repair_service" order="12-">
					<icon src="poi_repair_service.png"/>
				</itemgra>
				<itemgra item_types="poi_resort" order="12-">
					<icon src="poi_resort.png"/>
				</itemgra>
				<itemgra item_types="poi_restaurant" order="12-">
					<icon src="poi_restaurant.png"/>
				</itemgra>
				<itemgra item_types="poi_restricted_area" order="12-">
					<icon src="poi_restricted_area.png"/>
				</itemgra>
				<itemgra item_types="poi_restroom" order="13-">
					<icon src="poi_restroom.png"/>
				</itemgra>
				<itemgra item_types="poi_sailing" order="12-">
					<icon src="poi_sailing.png"/>
				</itemgra>
				<itemgra item_types="poi_scenic_area" order="12-">
					<icon src="poi_scenic_area.png"/>
				</itemgra>
				<itemgra item_types="poi_school" order="12-">
					<icon src="poi_school.png"/>
				</itemgra>
				<itemgra item_types="poi_service" order="12-">
					<icon src="poi_service.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_apparel" order="12-">
					<icon src="poi_shop_apparel.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_computer" order="12-">
					<icon src="poi_shop_computer.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_department" order="12-">
					<icon src="poi_shop_department.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_furniture" order="12-">
					<icon src="poi_shop_furnish.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_grocery" order="12-">
					<icon src="poi_shop_grocery.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_handg" order="12-">
					<icon src="poi_shop_handg.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_merchandise" order="12-">
					<icon src="poi_shop_merchandise.png"/>
				</itemgra>
				<itemgra item_types="poi_shop_retail" order="12-">
					<icon src="poi_shop_retail.png"/>
				</itemgra>
				<itemgra item_types="poi_shower" order="13-">
					<icon src="poi_shower.png"/>
				</itemgra>
				<itemgra item_types="poi_skiing" order="12-">
					<icon src="poi_skiing.png"/>
				</itemgra>
				<itemgra item_types="poi_social_service" order="12-">
					<icon src="poi_social_service.png"/>
				</itemgra>
				<itemgra item_types="poi_sounding" order="12-">
					<icon src="poi_sounding.png"/>
				</itemgra>
				<itemgra item_types="poi_sport" order="12-">
					<icon src="poi_sport.png"/>
				</itemgra>
				<itemgra item_types="poi_stadium" order="11-">
					<icon src="poi_stadium.png"/>
				</itemgra>
				<itemgra item_types="poi_swimming" order="12-">
					<icon src="poi_swimming.png"/>
				</itemgra>
				<itemgra item_types="poi_telephone" order="13-">
					<icon src="poi_telephone.png"/>
				</itemgra>
				<itemgra item_types="poi_theater" order="12-">
					<icon src="poi_theater.png"/>
				</itemgra>
				<itemgra item_types="poi_tide" order="12-">
					<icon src="poi_tide.png"/>
				</itemgra>
				<itemgra item_types="poi_tower" order="13-">
					<icon src="poi_tower.png"/>
				</itemgra>
				<itemgra item_types="poi_townhall" order="12-">
					<icon src="poi_townhall.png"/>
				</itemgra>
				<itemgra item_types="poi_trail" order="12-">
					<icon src="poi_trail.png"/>
				</itemgra>
				<itemgra item_types="poi_truck_stop" order="12-">
					<icon src="poi_truck_stop.png"/>
				</itemgra>
				<itemgra item_types="poi_tunnel" order="12-">
					<icon src="poi_tunnel.png"/>
				</itemgra>
				<itemgra item_types="poi_wine" order="12-">
					<icon src="poi_wine.png"/>
				</itemgra>
				<itemgra item_types="poi_worship" order="11-">
					<icon src="poi_worship.png"/>
				</itemgra>
				<itemgra item_types="poi_wrecker" order="12-">
					<icon src="poi_wrecker.png"/>
				</itemgra>
				<itemgra item_types="poi_zoo" order="11-">
					<icon src="poi_zoo.png"/>
				</itemgra>
				<itemgra item_types="poi_picnic" order="12-">
					<icon src="poi_picnic.png"/>
				</itemgra>
				<itemgra item_types="poi_gc_multi" order="12-">
					<icon src="poi_gc_multi.png"/>
				</itemgra>
				<itemgra item_types="poi_gc_tradi" order="12-">
					<icon src="poi_gc_tradi.png"/>
				</itemgra>
				<itemgra item_types="poi_gc_event" order="12-">
					<icon src="poi_gc_event.png"/>
				</itemgra>
				<itemgra item_types="poi_gc_mystery" order="12-">
					<icon src="poi_gc_mystery.png"/>
				</itemgra>
				<itemgra item_types="poi_gc_question" order="12-">
					<icon src="poi_gc_question.png"/>
				</itemgra>
				<itemgra item_types="poi_gc_stages" order="12-">
					<icon src="poi_gc_stages.png"/>
				</itemgra>
				<itemgra item_types="poi_gc_reference" order="12-">
					<icon src="poi_gc_reference.png"/>
				</itemgra>
				<itemgra item_types="poi_gc_webcam" order="12-">
					<icon src="poi_gc_webcam.png"/>
				</itemgra>
				<itemgra item_types="poi_wifi" order="13-">
					<icon src="poi_wifi.png"/>
				</itemgra>
				<itemgra item_types="poi_image" order="12-">
					<image/>
				</itemgra>
				<!-- I'm not sure if the following stuff should appear in any layout. Maybe portions should only apply to the bicyle layout. -->
				<itemgra item_types="poi_bench" order="13-">
					<icon src="poi_bench.png"/>
				</itemgra>
				<itemgra item_types="poi_biergarten" order="12-">
					<icon src="poi_biergarten.png"/>
				</itemgra>
				<itemgra item_types="poi_boundary_stone" order="13-">
					<icon src="poi_boundary_stone.png"/>
				</itemgra>
				<itemgra item_types="poi_castle" order="11-">
					<icon src="poi_castle.png"/>
				</itemgra>
				<itemgra item_types="poi_ruins" order="11-">
					<icon src="poi_ruins.png"/>
				</itemgra>
				<itemgra item_types="poi_hunting_stand" order="12-">
					<icon src="poi_hunting_stand.png"/>
				</itemgra>
				<itemgra item_types="poi_memorial" order="12-">
					<icon src="poi_memorial.png"/>
				</itemgra>
				<itemgra item_types="poi_monument" order="12-">
					<icon src="poi_memorial.png"/>
				</itemgra>
				<itemgra item_types="poi_shelter" order="11-">
					<icon src="poi_shelter.png"/>
				</itemgra>
				<itemgra item_types="poi_fountain" order="13-">
					<icon src="poi_fountain.png"/>
				</itemgra>
				<itemgra item_types="poi_potable_water" order="13-">
					<icon src="poi_potable_water.png"/>
				</itemgra>
				<itemgra item_types="poi_toilets" order="12-">
					<icon src="poi_toilets.png"/>
				</itemgra>
				<itemgra item_types="poi_viewpoint" order="11-">
					<icon src="poi_viewpoint.png"/>
				</itemgra>
				<itemgra item_types="tec_common" order="11-">
					<icon src="poi_tec_common.png" />
				</itemgra>
				<itemgra item_types="vehicle" order="0-">
					<icon src="poi_vehicle.png"/>
				</itemgra>
				<itemgra item_types="vehicle_pedestrian" order="0-">
					<icon src="poi_vehicle_pedestrian.png"/>
				</itemgra>
				<itemgra item_types="poi_custom0,poi_custom1,poi_custom2,poi_custom3,poi_custom4,poi_custom5,poi_custom6,poi_custom7,poi_custom8,poi_custom9,poi_customa,poi_customb,poi_customc,poi_customd,poi_custome,poi_customf" order="10-">
					<icon src="%s"/>
				</itemgra>
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="Android-POI-Labels-full" active="0">
				<itemgra item_types="poi_airport,town_ghost,poi_hotel,poi_car_parking,poi_car_dealer_parts,poi_fuel,poi_shopping,poi_attraction,poi_cafe,poi_bar,highway_exit,poi_camp_rv,poi_museum_history,poi_hospital,poi_dining,poi_fastfood,poi_police,poi_autoservice,poi_bank,poi_bus_station,poi_bus_stop,poi_business_service,poi_car_rent,poi_church,poi_cinema,poi_concert,poi_drinking_water,poi_emergency,poi_fair,poi_fish,poi_government_building,poi_hotspring,poi_information,poi_justice,poi_landmark,poi_library,poi_mall,poi_manmade_feature,poi_marine,poi_marine_type,poi_mark,poi_oil_field,poi_peak,poi_personal_service,poi_pharmacy,poi_post_office,poi_public_office,poi_rail_halt,poi_rail_station,poi_rail_tram_stop,poi_repair_service,poi_resort,poi_restaurant,poi_restricted_area,poi_sailing,poi_scenic_area,poi_school,poi_service,poi_shop_retail,poi_skiing,poi_social_service,poi_sport,poi_stadium,poi_swimming,poi_theater,poi_townhall,poi_trail,poi_truck_stop,poi_tunnel,poi_worship,poi_wrecker,poi_zoo,poi_biergarten,poi_castle,poi_ruins,poi_memorial,poi_monument,poi_shelter,poi_fountain,poi_viewpoint,vehicle" order="14-">
					<circle color="#606060" radius="0" width="0" text_size="10"/>
				</itemgra>
				<itemgra item_types="poi_custom0,poi_custom1,poi_custom2,poi_custom3,poi_custom4,poi_custom5,poi_custom6,poi_custom7,poi_custom8,poi_custom9,poi_customa,poi_customb,poi_customc,poi_customd,poi_custome,poi_customf" order="14-">
					<circle color="#606060" radius="0" width="0" text_size="10"/>
				</itemgra>
			</layer>

		<xsl:text>&#x0A;        </xsl:text>


			<layer name="POI bicycle" active="0">
				<itemgra item_types="poi_bicycle_parking" order="14-15">
					<circle color="#000000" radius="11" width="10" text_size="12"/>
					<circle color="#1547C8" radius="7" width="8"/>
				</itemgra>
				<itemgra item_types="poi_bicycle_parking" order="16-">
					<circle color="#000000" radius="20" width="15" text_size="20"/>
					<circle color="#1547C8" radius="10" width="20"/>
				</itemgra>
				<itemgra item_types="poi_bicycle_rental" order="14-15">
					<circle color="#000000" radius="11" width="10" text_size="12"/>
					<circle color="#FEFE00" radius="7" width="8"/>
				</itemgra>
				<itemgra item_types="poi_bicycle_rental" order="16-">
					<circle color="#000000" radius="20" width="15" text_size="20"/>
					<circle color="#FEFE00" radius="10" width="20"/>
				</itemgra>
				<itemgra item_types="traffic_crossing_signal" order="15">
					<circle color="#000000" radius="8" width="6"/>
					<circle color="#00C000" radius="4" width="4"/>
				</itemgra>
				<itemgra item_types="traffic_crossing_signal" order="16-">
					<circle color="#000000" radius="15" width="10"/>
					<circle color="#00C000" radius="8" width="8"/>
				</itemgra>
<!--
				<itemgra item_types="traffic_crossing_uncontrolled" order="13-15">
					<circle color="#000000" radius="8" width="6"/>
					<circle color="#FEFE00" radius="4" width="4"/>
				</itemgra>
				<itemgra item_types="traffic_crossing_uncontrolled" order="16-">
					<circle color="#000000" radius="15" width="10"/>
					<circle color="#FEFE00" radius="8" width="8"/>
				</itemgra>
-->
			</layer>

		<xsl:text>&#x0A;        </xsl:text>

			<layer name="RouteArrows" active="1">
			</layer>

		<xsl:text>&#x0A;        </xsl:text>


			<layer name="NavNav" active="1">

				<!-- route graph -->
				<itemgra item_types="rg_segment" order="13-">
					<polyline color="#FF089C" width="3"/>
					<arrows color="#FF089C" width="3"/>
					<text text_size="17"/>
				</itemgra>


				<itemgra item_types="rg_point" order="13-">
					<circle color="#FF089C" radius="10" text_size="13"/>
				</itemgra>
				<!-- route graph -->


				<itemgra item_types="nav_left_1" order="0-">
					<icon src="nav_left_1_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_left_2" order="0-">
					<icon src="nav_left_2_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_left_3" order="0-">
					<icon src="nav_left_3_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_right_1" order="0-">
					<icon src="nav_right_1_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_right_2" order="0-">
					<icon src="nav_right_2_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_right_3" order="0-">
					<icon src="nav_right_3_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_straight" order="0-">
					<icon src="nav_straight_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_turnaround" order="0-">
					<icon src="nav_turnaround_left_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_l1" order="0-">
					<icon src="nav_roundabout_l1_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_r1" order="0-">
					<icon src="nav_roundabout_r1_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_l2" order="0-">
					<icon src="nav_roundabout_l2_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_r2" order="0-">
					<icon src="nav_roundabout_r2_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_l3" order="0-">
					<icon src="nav_roundabout_l3_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_r3" order="0-">
					<icon src="nav_roundabout_r3_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_l4" order="0-">
					<icon src="nav_roundabout_l4_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_r4" order="0-">
					<icon src="nav_roundabout_r4_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_l5" order="0-">
					<icon src="nav_roundabout_l5_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_r5" order="0-">
					<icon src="nav_roundabout_r5_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_l6" order="0-">
					<icon src="nav_roundabout_l6_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_r6" order="0-">
					<icon src="nav_roundabout_r6_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_l7" order="0-">
					<icon src="nav_roundabout_l7_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_r7" order="0-">
					<icon src="nav_roundabout_r7_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_l8" order="0-">
					<icon src="nav_roundabout_l8_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>
				<itemgra item_types="nav_roundabout_r8" order="0-">
					<icon src="nav_roundabout_r8_bk.png" w="32" h="32"/>
					<circle color="#FF0000" radius="10" text_size="7"/>
				</itemgra>



				<itemgra item_types="route_end" order="0-">
					<icon src="nav_destination_bk_center.png" w="32" h="32"/>
					<!--<circle color="#FF0000" radius="10" text_size="7"/>-->
				</itemgra>



				<itemgra item_types="nav_none" order="0-">
					<circle color="#FF0000" radius="40" width="9" text_size="7"/>
					<icon src="mini_roundabout.png"/>
				</itemgra>

				<itemgra item_types="nav_position" order="0-">
					<circle color="#00FF00" radius="40" width="9" text_size="7"/>
					<icon src="mini_roundabout.png"/>
				</itemgra>

				<itemgra item_types="nav_destination" order="0-">
					<circle color="#0000FF" radius="40" width="9" text_size="7"/>
				</itemgra>

<!--
				<itemgra item_types="announcement" order="{round(7-number($LAYOUT_001_ORDER_DELTA_1))}-">
					<icon src="gui_sound_32_32.png"/>
					<circle color="#FF089C" radius="10" text_size="7"/>
				</itemgra>
-->

			</layer>


		<xsl:text>&#x0A;        </xsl:text>


			<layer name="TurnRestrictions" active="0">

				<itemgra item_types="street_turn_restriction_no" order="7-">
					<polyline color="#FF0000" width="22"/>
				</itemgra>

				<itemgra item_types="street_turn_restriction_only" order="7-">
					<polyline color="#00FF00" width="22"/>
				</itemgra>
			</layer>



		<xsl:text>&#x0A;        </xsl:text>

		<!-- android layout -->
		<!-- android layout -->
		<!-- android layout -->
		<xsl:text>&#x0A;        </xsl:text>
</layout>
		<xsl:text>&#x0A;        </xsl:text>
		<xsl:copy><xsl:copy-of select="@*|node()"/></xsl:copy>
	</xsl:template>
        <xsl:template match="/config/navit/layout[@name='XXRouteXX']">
<xsl:text>&#x0A;        </xsl:text>
		<layout name="Route">
<xsl:text>&#x0A;        </xsl:text>
			<layer name="streets">
<xsl:text>&#x0A;        </xsl:text>
				<itemgra item_types="street_route_occluded" order="0-">
<xsl:text>&#x0A;        </xsl:text>
					<polyline color="#69e068" width="20"/>
<xsl:text>&#x0A;        </xsl:text>
				</itemgra>
<xsl:text>&#x0A;        </xsl:text>
			</layer>
<xsl:text>&#x0A;        </xsl:text>
		</layout>
<xsl:text>&#x0A;        </xsl:text>
	</xsl:template>
	<!-- add new default look-and-feel for android -->
        <xsl:template match="/config/navit/speech">
                <xsl:copy><xsl:copy-of select="@*[not(name()='data')]"/><xsl:attribute name="type">android</xsl:attribute><xsl:apply-templates/></xsl:copy>
	</xsl:template>
        <xsl:template match="@*|node()"><xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy></xsl:template>
</xsl:transform>
