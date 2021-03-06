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

#include <glib.h>
#include "debug.h"
#include "plugin.h"
#include "item.h"
#include "color.h"
#include "point.h"
#include "navit.h"
#include "graphics.h"
#include "command.h"
#include "callback.h"
#include "osd.h"

struct osd
{
	struct osd_methods meth;
	struct osd_priv *priv;
};

static GHashTable *osd_hash = NULL;

struct osd *
osd_new(struct attr *parent, struct attr **attrs)
{
	struct attr *attr;
	struct osd *o;
	struct osd_priv *(*new)(struct navit *nav, struct osd_methods *meth, struct attr **attrs);
	struct attr *type = attr_search(attrs, NULL, attr_type);

	if (!type)
	{
		return NULL;
	}

#ifdef PLUGSSS
	//dbg(0, "oo 001\n");
	new = plugin_get_osd_type(type->u.str);
	//dbg(0, "oo 002\n");
	if (!new)
	{
		return NULL;
	}
#endif

	o=g_new0(struct osd, 1);

	dbg(0, "osd_new:type=%s\n", type->u.str);

#ifdef PLUGSSS
	o->priv = new(parent->u.navit, &o->meth, attrs);
#else
	if (strncmp("compass", type->u.str, 7) == 0)
	{
		o->priv = osd_compass_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("navigation_next_turn", type->u.str, 20) == 0)
	{
		o->priv = osd_nav_next_turn_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("button", type->u.str, 6) == 0)
	{
		o->priv = osd_button_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("toggle_announcer", type->u.str, 16) == 0)
	{
		o->priv = osd_nav_toggle_announcer_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("speed_warner", type->u.str, 12) == 0)
	{
		o->priv = osd_speed_warner_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("speed_cam", type->u.str, 9) == 0)
	{
		o->priv = osd_speed_cam_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("text", type->u.str, 4) == 0)
	{
		o->priv = osd_text_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("gps_status", type->u.str, 10) == 0)
	{
		o->priv = osd_gps_status_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("volume", type->u.str, 6) == 0)
	{
		o->priv = osd_volume_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("scale", type->u.str, 5) == 0)
	{
		o->priv = osd_scale_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("image", type->u.str, 5) == 0)
	{
		o->priv = osd_image_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("stopwatch", type->u.str, 9) == 0)
	{
		o->priv = osd_stopwatch_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("odometer", type->u.str, 8) == 0)
	{
		o->priv = osd_odometer_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("auxmap", type->u.str, 6) == 0)
	{
		o->priv = osd_auxmap_new(parent->u.navit, &o->meth, attrs);
	}
	else if (strncmp("cmd_interface", type->u.str, 13) == 0)
	{
		o->priv = osd_cmd_interface_new(parent->u.navit, &o->meth, attrs);
	}
#endif

	dbg(0, "osd_new:ready\n");

	attr = attr_search(attrs, NULL, attr_name);
	if (attr && attr->u.str)
	{
		if (NULL == osd_hash)
		{
			//dbg(0, "oo 005\n");
			osd_hash = g_hash_table_new_full(g_str_hash, g_str_equal, g_free_func, NULL);
		}
		//dbg(0, "oo 006\n");
		g_hash_table_insert(osd_hash, g_strdup(attr->u.str), o);
	}
	//dbg(0, "oo 007\n");

	return o;
}

struct osd*
osd_get_osd_by_name(char *name)
{
	return g_hash_table_lookup(osd_hash, name);
}

int osd_set_attr(struct osd *osd, struct attr* attr)
{
	if (osd && osd->meth.set_attr)
	{
		osd->meth.set_attr(osd->priv, attr);
	}
	return 0;
}

void osd_wrap_point(struct point *p, struct navit *nav)
{
	if (p->x < 0)
		p->x += navit_get_width(nav);
	if (p->y < 0)
		p->y += navit_get_height(nav);

}

static void osd_evaluate_command(struct osd_item *this, struct navit *nav)
{
	struct attr navit;
	navit.type = attr_navit;
	navit.u.navit = nav;
	//dbg(0, "calling command '%s'\n", this->command);
	command_evaluate(&navit, this->command);
}

void osd_std_click(struct osd_item *this, struct navit *nav, int pressed, int button, struct point *p)
{
	/*
	 struct point bp = this->p;
	 if (!this->command || !this->command[0])
	 return;
	 osd_wrap_point(&bp, nav);
	 if ((p->x < bp.x || p->y < bp.y || p->x > bp.x + this->w || p->y > bp.y + this->h || !this->configured) && !this->pressed)
	 return;
	 if (button != 1)
	 return;
	 if (!!pressed == !!this->pressed)
	 return;
	 if (navit_ignore_button(nav))
	 return;
	 this->pressed = pressed;
	 if (pressed && this->command)
	 osd_evaluate_command(this, nav);
	 */
}

void osd_std_resize(struct osd_item *item)
{
	// graphics_overlay_resize(item->gr, &item->p, item->w, item->h, 65535, 1);
}

static void osd_std_calculate_sizes(struct osd_item *item, struct osd_priv *priv, int w, int h)
{
	/*
	 struct attr vehicle_attr;

	 if (item->rel_w) {
	 item->w = (item->rel_w * w) / 100;
	 }

	 if (item->rel_h) {
	 item->h = (item->rel_h * h) / 100;
	 }

	 if (item->rel_x) {
	 item->p.x = (item->rel_x * w) / 100;
	 }

	 if (item->rel_y) {
	 item->p.y = (item->rel_y * h) / 100;
	 }

	 osd_std_resize(item);
	 if (item->meth.draw) {
	 if (navit_get_attr(item->navit, attr_vehicle, &vehicle_attr, NULL)) {
	 item->meth.draw(priv, item->navit, vehicle_attr.u.vehicle);
	 }
	 }
	 */
}

static void osd_std_keypress(struct osd_item *item, struct navit *nav, char *key)
{
#if 0
	int i;
	dbg(0,"key=%s\n",key);
	for (i = 0; i < strlen(key); i++)
	{
		dbg(0,"key:0x%02x\n",key[i]);
	}
	for (i = 0; i < strlen(item->accesskey); i++)
	{
		dbg(0,"accesskey:0x%02x\n",item->accesskey[i]);
	}
#endif
	if (item->accesskey && key && !strcmp(key, item->accesskey))
		osd_evaluate_command(item, nav);
}

static void osd_std_reconfigure(struct osd_item *item, struct command_saved *cs)
{
	/*
	 if (!command_saved_error(cs)) {
	 graphics_overlay_disable(item->gr, !command_saved_get_int(cs));
	 } else {
	 dbg(0, "Error in saved command: %i\n", command_saved_error(cs));
	 }
	 */
}

void osd_set_std_attr(struct attr **attrs, struct osd_item *item, int flags)
{
	struct attr *attr;

	item->flags = flags;
	item->osd_configuration = -1;
	item->color_white.r = 0xffff;
	item->color_white.g = 0xffff;
	item->color_white.b = 0xffff;
	item->color_white.a = 0xffff;
	item->text_color.r = 0xffff;
	item->text_color.g = 0xffff;
	item->text_color.b = 0xffff;
	item->text_color.a = 0xffff;
	if (flags & 1)
	{
		item->color_bg.r = 0x0808;
		item->color_bg.g = 0x0808;
		item->color_bg.b = 0xf8f8;
		item->color_bg.a = 0x0000;
	}
	else
	{
		item->color_bg.r = 0x0;
		item->color_bg.g = 0x0;
		item->color_bg.b = 0x0;
		item->color_bg.a = 0x5fff;
	}

	attr = attr_search(attrs, NULL, attr_osd_configuration);
	if (attr)
		item->osd_configuration = attr->u.num;

	attr = attr_search(attrs, NULL, attr_enable_expression);
	if (attr)
	{
		item->enable_cs = command_saved_new(attr->u.str, item->navit, NULL);
	}

	attr = attr_search(attrs, NULL, attr_w);
	if (attr)
	{
		if (attr->u.num > ATTR_REL_MAXABS)
		{
			item->rel_w = attr->u.num - ATTR_REL_RELSHIFT;
		}
		else
		{
			item->rel_w = 0;
			item->w = attr->u.num;
		}
	}

	attr = attr_search(attrs, NULL, attr_h);
	if (attr)
	{
		if (attr->u.num > ATTR_REL_MAXABS)
		{
			item->rel_h = attr->u.num - ATTR_REL_RELSHIFT;
		}
		else
		{
			item->rel_h = 0;
			item->h = attr->u.num;
		}
	}

	attr = attr_search(attrs, NULL, attr_x);
	if (attr)
	{
		if (attr->u.num > ATTR_REL_MAXABS)
		{
			item->rel_x = attr->u.num - ATTR_REL_RELSHIFT;
		}
		else
		{
			item->rel_x = 0;
			item->p.x = attr->u.num;
		}
	}

	attr = attr_search(attrs, NULL, attr_y);
	if (attr)
	{
		if (attr->u.num > ATTR_REL_MAXABS)
		{
			item->rel_y = attr->u.num - ATTR_REL_RELSHIFT;
		}
		else
		{
			item->rel_y = 0;
			item->p.y = attr->u.num;
		}
	}

	attr = attr_search(attrs, NULL, attr_font_size);
	if (attr)
		item->font_size = attr->u.num;

	attr = attr_search(attrs, NULL, attr_background_color);
	if (attr)
		item->color_bg = *attr->u.color;
	attr = attr_search(attrs, NULL, attr_command);
	if (attr)
		item->command = g_strdup(attr->u.str);
	attr = attr_search(attrs, NULL, attr_text_color);
	if (attr)
		item->text_color = *attr->u.color;
	attr = attr_search(attrs, NULL, attr_flags);
	if (attr)
		item->attr_flags = attr->u.num;
	attr = attr_search(attrs, NULL, attr_accesskey);
	if (attr)
		item->accesskey = g_strdup(attr->u.str);
	attr = attr_search(attrs, NULL, attr_font);
	if (attr)
		item->font_name = g_strdup(attr->u.str);

}
void osd_std_config(struct osd_item *item, struct navit *navit)
{
	struct attr attr;
	//dbg(1, "enter\n");
	if (item->enable_cs)
	{
		item->reconfig_cb = callback_new_1(callback_cast(osd_std_reconfigure), item);
		command_saved_set_cb(item->enable_cs, item->reconfig_cb);

		if (!command_saved_error(item->enable_cs))
		{
			item->configured = !!command_saved_get_int(item->enable_cs);
		}
		else
		{
			//dbg(0, "Error in saved command: %i.\n", command_saved_error(item->enable_cs));
		}
	}
	else
	{
		if (!navit_get_attr(navit, attr_osd_configuration, &attr, NULL))
			attr.u.num = -1;
		item->configured = !!(attr.u.num & item->osd_configuration);
	}

	//if (item->gr && !(item->flags & 16)) 
	//	graphics_overlay_disable(item->gr, !item->configured);
}

void osd_set_std_config(struct navit *nav, struct osd_item *item)
{
	item->cb = callback_new_attr_2(callback_cast(osd_std_config), attr_osd_configuration, item, nav);
	callback_add_names(item->cb, "osd_set_std_config", "osd_std_config");
	navit_add_callback(nav, item->cb);
	osd_std_config(item, nav);
}

void osd_set_std_graphic(struct navit *nav, struct osd_item *item, struct osd_priv *priv)
{
	// struct graphics *navit_gr;

	// navit_gr = navit_get_graphics(nav);
	item->gr = NULL;
	// DISABLE OVERLAYS // graphics_overlay_new(navit_gr, &item->p, item->w, item->h, 65535, 1);

	// item->graphic_bg = graphics_gc_new(item->gr);
	// graphics_gc_set_foreground(item->graphic_bg, &item->color_bg);
	// graphics_background_gc(item->gr, item->graphic_bg);

	// item->graphic_fg_white = graphics_gc_new(item->gr);
	// graphics_gc_set_foreground(item->graphic_fg_white, &item->color_white);

	// if (item->flags & 2) {
	// 	item->font = graphics_named_font_new(item->gr, item->font_name, item->font_size, 1);
	// 	item->graphic_fg_text = graphics_gc_new(item->gr);
	// 	graphics_gc_set_foreground(item->graphic_fg_text, &item->text_color);
	// }

	osd_set_std_config(nav, item);

	item->resize_cb = callback_new_attr_2(callback_cast(osd_std_calculate_sizes), attr_resize, item, priv);
	callback_add_names(item->resize_cb, "osd_set_std_graphic", "osd_std_calculate_sizes");

	// graphics_add_callback(navit_gr, item->resize_cb);
	//dbg(0, "accesskey %s\n", item->accesskey);
	// if (item->accesskey) {
	// 	item->keypress_cb=callback_new_attr_2(callback_cast(osd_std_keypress), attr_keypress, item, nav);
	// 	graphics_add_callback(navit_gr, item->keypress_cb);
	// }

}

void osd_std_draw(struct osd_item *item)
{
	/*

	 struct point p[2];
	 int flags=item->attr_flags;

	 graphics_draw_mode(item->gr, draw_mode_begin);
	 p[0].x=0;
	 p[0].y=0;
	 graphics_draw_rectangle(item->gr, item->graphic_bg, p, item->w, item->h);
	 p[1].x=item->w-1;
	 p[1].y=0;
	 if (flags & 1)
	 graphics_draw_lines(item->gr, item->graphic_fg_text, p, 2);
	 p[0].x=item->w-1;
	 p[0].y=item->h-1;
	 if (flags & 2)
	 graphics_draw_lines(item->gr, item->graphic_fg_text, p, 2);
	 p[1].x=0;
	 p[1].y=item->h-1;
	 if (flags & 4)
	 graphics_draw_lines(item->gr, item->graphic_fg_text, p, 2);
	 p[0].x=0;
	 p[0].y=0;
	 if (flags & 8)
	 graphics_draw_lines(item->gr, item->graphic_fg_text, p, 2);

	 */
}

