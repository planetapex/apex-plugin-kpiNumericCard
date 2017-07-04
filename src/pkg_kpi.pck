create or replace package pkg_kpi is

  -- Author  : M Yasir Ali Shah
  -- Created : 16/4/2017 12:14:13 AM
  -- Purpose :
  function f_render(p_region              in apex_plugin.t_region,
                    p_plugin              in apex_plugin.t_plugin,
                    p_is_printer_friendly in boolean)
    return apex_plugin.t_region_render_result;

  function f_ajax(p_region in apex_plugin.t_region,
                  p_plugin in apex_plugin.t_plugin)
    return apex_plugin.t_region_ajax_result;

  function f_render_guage(p_region              in apex_plugin.t_region,
                          p_plugin              in apex_plugin.t_plugin,
                          p_is_printer_friendly in boolean)
    return apex_plugin.t_region_render_result;

end pkg_kpi;
/
create or replace package body pkg_kpi is

  /****************************************************************************************
  ****************************************************************************************
  **  Plugin      : KPI Numeri Cards
  **  InternalName: COM.PLANETAPEX.KPI_NUMERIC_CARDS
  **  Author      : M.Yasir Ali Shah
  **  Date        : Tuesday, July 4, 2017
  **  Version     : 1.0
  **  Description : This Apex plugin displays KPI information in the form of Numeric Cards.
  **  Modification:
  **  Change Log  1) 1.0 - Initial Release -
  **  gitHub Repo : https://github.com/planetapex/apex-plugin-kpiNumericCards
  **  Website     : https://apexfusion.blogspot.com/  **
  ****************************************************************************************
  ****************************************************************************************/

  g_title_col  constant number(1) := 1;
  g_value_col  constant number(1) := 2;
  g_trend_col  constant number(1) := 3;
  g_symbol_col constant number(1) := 4;
  g_footer_col constant number(1) := 5;
  g_link_col   constant number(1) := 6;
  -- g_value_col   constant number(1) := 3;

  FUNCTION f_yn_2_truefalse(p_val IN VARCHAR2) RETURN boolean AS
  BEGIN
    RETURN case NVL(p_val, 'N') when 'Y' then true else false end;
  END f_yn_2_truefalse;

  function f_render(p_region              in apex_plugin.t_region,
                    p_plugin              in apex_plugin.t_plugin,
                    p_is_printer_friendly in boolean)
    return apex_plugin.t_region_render_result is
    l_render_result apex_plugin.t_region_render_result;
  
    -- Region Plugin Attributes
    -----------------------------------------
    subtype attr is p_region.attribute_01%type;
  
    -- atr_start_row boolean := f_yn_2_truefalse(p_region.attribute_0);
  
    atr_templ INTEGER := TO_NUMBER(p_region.attribute_02);
  
    l_html    varchar2(32767);
    l_js_code varchar2(32767);
    v_Options varchar2(32767); --Options per Chart
 
  
  begin
   /* apex_application.show_error_message(p_message => 'asd',
                                        p_footer  => apex_plugin_util.replace_substitutions(p_value  => c_link_target,
                                                                           p_escape => false));
 */   /*   apex_css.add_file(p_name      => 'jquery.circliful',
    p_directory => apex_application.g_image_prefix ||
                   'libraries/circa/css/');*/
  
    apex_json.initialize_clob_output;
    apex_json.open_object; --{
  
    apex_json.open_array('cards');
    apex_json.open_object;
    apex_json.close_object;
    apex_json.close_array;
  
    apex_json.write('ajaxIdentifier', apex_plugin.get_ajax_identifier);
    apex_json.write('pageItems',
                    apex_plugin_util.page_item_names_to_jquery(p_region.ajax_items_to_submit));
    apex_json.write('templateNo', atr_templ);
    apex_json.write('noDataFoundMessage', p_region.no_data_found_message);
  
    /* if l_col_val_list(l_col_val_list.first).value_list.count = 0 then
      apex_json.write('noData', true);
    else
      apex_json.write('noData', false);
    end if;*/
  
    apex_json.close_object;
    v_Options := apex_json.get_clob_output;
  
    apex_json.free_output;
  
    /*  apex_application.show_error_message(p_message => 'asd',
    p_footer  =>apex_json.get_clob_output );*/
  
    l_js_code := 'apex.jQuery("#' || p_region.static_id ||
                 '").kpiNumCards(' || v_Options || ');';
  
    apex_javascript.add_onload_code(p_code => l_js_code);
  
    return l_render_result;
  
  end f_render;

  function f_ajax(p_region in apex_plugin.t_region,
                  p_plugin in apex_plugin.t_plugin)
    return apex_plugin.t_region_ajax_result is
    l_ajax_result apex_plugin.t_region_ajax_result;
  
    atr_col_span APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_03,
                                                                              ',');
  
    atr_height APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_04,
                                                                            ',');
  
    atr_hdr_bkgrnd_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_05,
                                                                                      ',');
  
    atr_hdr_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_06,
                                                                                    ',');
  
    atr_hdr_font_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_07,
                                                                                   ',');
  
    atr_card_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_08,
                                                                                ',');
    atr_text_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_09,
                                                                                ',');
  
    atr_text_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_10,
                                                                               ',');
  
    atr_ftr_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_11,
                                                                                    ',');
  
    atr_ftr_font_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_12,
                                                                                   ',');
 
    
    c_link_target  p_region.attribute_18%type := p_region.attribute_18;
/*    c_link_target   constant varchar2(255) := p_region.attribute_18;*/
    /* atr_hdr_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_06,
                                                                                    ',');
    
    atr_hdr_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_06,
                                                                                    ',');
    */
  
    --Options for the plugin
    ---------------------------------------
    -- v_Options clob;
  
    l_arr_lst APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_val     varchar2(32767);
  
    l_tk  APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_opt APEX_APPLICATION_GLOBAL.VC_ARR2;
  
    TYPE ass_tab IS TABLE OF VARCHAR2(100);
    aar_opts   ass_tab;
    aar_sels   ass_tab := ass_tab();
    aar_unsels ass_tab := ass_tab();
    l_idx      Integer;
  
    -- code variables
    -------------------
    l_html    varchar2(32767);
    l_js_code varchar2(32767);
  
    l_crlf char(2) := chr(13) || chr(10);
  
    --LIST QUERY
    --==========================================
    -- It's better to have named variables instead of using the generic ones,
    -- makes the code more readable. We are using the same defaults for the
    -- required attributes as in the plug-in attribute configuration, because
    -- they can still be null. Keep them in sync!
    c_title_column  constant varchar2(255) := p_region.attribute_13;
    c_value_column  constant varchar2(255) := p_region.attribute_14;
    c_symbol_column constant varchar2(255) := p_region.attribute_15;
    c_trend_column  constant varchar2(255) := p_region.attribute_16;
    c_footer_column constant varchar2(255) := p_region.attribute_17;
   /* c_link_target   constant varchar2(255) := p_region.attribute_18;*/
  
    l_title_column_no  pls_integer;
    l_value_column_no  pls_integer;
    l_symbol_column_no pls_integer;
    l_trend_column_no  pls_integer;
    l_footer_column_no pls_integer;
    l_url_column_no    pls_integer;
  
    l_column_value_list apex_plugin_util.t_column_value_list2;
  
    l_title  varchar2(4000);
    l_value  number;
    l_trend  varchar2(4);
    l_symbol varchar2(4);
    l_footer varchar2(4000);
    l_url    varchar2(4000);
  
    l_query              clob;
    l_lst_type           varchar2(50);
    l_col_data_type_list apex_application_global.vc_arr2;
    --  l_col_val_list       apex_plugin_util.t_column_value_list2;
  
  begin
  
    apex_plugin_util.print_json_http_header;
    apex_json.initialize_output(p_http_cache => false);
    -- begin output as json
    /* owa_util.mime_header('application/json', false);
    htp.p('cache-control: no-cache');
    htp.p('pragma: no-cache');
    owa_util.http_header_close; */
  
    apex_json.open_object; --{
    apex_json.open_array('cards');
  
    -- Read the data based on the region source query
    l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => p_region.source,
                                                      p_min_columns    => 2,
                                                      p_max_columns    => null,
                                                      p_component_name => p_region.name);
  
    -- Get the actual column# for faster access and also verify that the data type
    -- of the column matches with what we are looking for
    -- the first column is the title(null or '...' and string
    -- the 2nd column is the percentage value(0 or greater) and number
    -- the 3rd column is the Target percentage value(0 or greater) and number
    -- the 4th column is the font awesome icon(null or icon name) and string
    l_title_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Title Column',
                                                        p_column_alias      => c_title_column,
                                                        p_column_value_list => l_column_value_list,
                                                        p_is_required       => true,
                                                        p_data_type         => apex_plugin_util.c_data_type_varchar2);
  
    l_value_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Value Column',
                                                        p_column_alias      => c_value_column,
                                                        p_column_value_list => l_column_value_list,
                                                        p_is_required       => true,
                                                        p_data_type         => apex_plugin_util.c_data_type_number);
  
    l_symbol_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Symbol Column',
                                                         p_column_alias      => c_symbol_column,
                                                         p_column_value_list => l_column_value_list,
                                                         p_is_required       => false,
                                                         p_data_type         => apex_plugin_util.c_data_type_varchar2);
  
    l_trend_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Trend Column',
                                                        p_column_alias      => c_trend_column,
                                                        p_column_value_list => l_column_value_list,
                                                        p_is_required       => false,
                                                        p_data_type         => apex_plugin_util.c_data_type_varchar2);
  
    l_footer_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Footer Column',
                                                         p_column_alias      => c_footer_column,
                                                         p_column_value_list => l_column_value_list,
                                                         p_is_required       => false,
                                                         p_data_type         => apex_plugin_util.c_data_type_varchar2);
  
    /* l_url_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Link Target',
                                                        p_column_alias      => c_link_target,
                                                        p_column_value_list => l_column_value_list,
                                                        p_is_required       => false,
                                                        p_data_type         => apex_plugin_util.c_data_type_varchar2);
    */
    for l_row_num in 1 .. l_column_value_list(1).value_list.count loop
      Begin
        l_title  := null;
        l_value  := 0;
        l_symbol := null;
        l_trend  := '';
        l_footer := null;
      
        -- Set the column values of our current row so that apex_plugin_util.replace_substitutions
        -- can do substitutions for columns contained in the region source query.
        apex_plugin_util.set_component_values(p_column_value_list => l_column_value_list,
                                              p_row_num           => l_row_num);
      
        -- get the title
        l_title := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_title_column_no)
                                                                         .data_type,
                                                          p_value     => l_column_value_list(l_title_column_no)
                                                                         .value_list(l_row_num));
        --  p_region.escape_output );apex_plugin_util.escape (
      
        -- get the value
        l_value := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_value_column_no)
                                                                         .data_type,
                                                          p_value     => l_column_value_list(l_value_column_no)
                                                                         .value_list(l_row_num));
      
        -- get symbol
        if l_symbol_column_no is not null then
          l_symbol := l_column_value_list(l_symbol_column_no).value_list(l_row_num)
                      .varchar2_value;
        
        end if;
      
        -- get trend
        if l_trend_column_no is not null then
          l_trend := l_column_value_list(l_trend_column_no).value_list(l_row_num)
                     .varchar2_value;
        
        end if;
      
        -- get footer
        if l_footer_column_no is not null then
          l_footer := l_column_value_list(l_footer_column_no).value_list(l_row_num)
                      .varchar2_value;
        
        end if;
      
        -- get the link target if it does exist
        if c_link_target is not null then
          l_url := apex_util.prepare_url(apex_plugin_util.replace_substitutions(p_value  => htf.escape_sc(c_link_target),
                                                                                p_escape => true));
        
        end if;
      
        /*   -- get the link col if it does exist
        if l_url_column_no is not null then
          l_url := apex_util.prepare_url(apex_plugin_util.replace_substitutions(p_value  => l_column_value_list(l_url_column_no).value_list(l_row_num)
                                                                                            .varchar2_value,
                                                                                p_escape => false));
        end if;*/
      
        ---Template--
        --=======================
        apex_json.open_object;
        apex_json.write('colSpan',
                        case when
                        atr_col_span.exists(l_row_num) AND
                        atr_col_span(l_row_num) is NOT NULL AND
                        TO_NUMBER(atr_col_span(l_row_num)) between 1 and 12 then
                        atr_col_span(l_row_num) else 3 end);
      
        --==Query Columns and Main Values==---
        ---------------------------------
      
        apex_json.write('title', l_title);
        apex_json.write('footer', l_footer);
      
        apex_json.open_object('data');
        apex_json.write('value', l_value);
        apex_json.write('trend', l_trend);
        apex_json.write('symbol', l_symbol);
        apex_json.close_object;
      
        apex_json.write('url', l_url);
      
        --End "Query Columns and Main Values"
        -------------------------------------------------------
      
        apex_json.write('height',
                        case when atr_height.exists(l_row_num) then
                        atr_height(l_row_num) end);
      
        apex_json.write('headerColor',
                        case when atr_hdr_bkgrnd_color.exists(l_row_num) then
                        atr_hdr_bkgrnd_color(l_row_num) end);
      
        apex_json.write('headerFontColor',
                        case when atr_hdr_font_color.exists(l_row_num) then
                        atr_hdr_font_color(l_row_num) end);
      
        apex_json.write('headerFontSize',
                        case when atr_hdr_font_size.exists(l_row_num) then
                        atr_hdr_font_size(l_row_num) end);
      
        apex_json.write('cardColor',
                        case when atr_card_color.exists(l_row_num) then
                        atr_card_color(l_row_num) end);
      
        apex_json.write('cardTextColor',
                        case when atr_text_color.exists(l_row_num) then
                        atr_text_color(l_row_num) end);
      
        apex_json.write('cardTextSize',
                        case when atr_text_size.exists(l_row_num) then
                        atr_text_size(l_row_num) end);
      
        apex_json.write('FooterTextColor',
                        case when atr_ftr_font_color.exists(l_row_num) then
                        atr_ftr_font_color(l_row_num) end);
      
        apex_json.write('FooterTextSize',
                        case when atr_ftr_font_size.exists(l_row_num) then
                        atr_ftr_font_size(l_row_num) end);
      
        apex_json.close_object;
      
        apex_plugin_util.clear_component_values;
      exception
        when others then
          apex_plugin_util.clear_component_values;
          raise;
      end;
    
    End loop;
  
    apex_json.close_array;
  
    apex_json.write('pageItems',
                    apex_plugin_util.page_item_names_to_jquery(p_region.ajax_items_to_submit));
  
    apex_json.close_object;
  
    --  apex_plugin_util.clear_component_values;
  
    return null;
  exception
    when others then
      htp.p('error: ' || apex_escape.html(sqlerrm));
      return null;
  end f_ajax;

  function ajax_badge(p_region in apex_plugin.t_region,
                      p_plugin in apex_plugin.t_plugin)
    return apex_plugin.t_region_ajax_result is
    -- It's better to have named variables instead of using the generic ones,
    -- makes the code more readable. We are using the same defaults for the
    -- required attributes as in the plug-in attribute configuration, because
    -- they can still be null. Keep them in sync!
    c_label_column   constant varchar2(255) := p_region.attribute_01;
    c_value_column   constant varchar2(255) := p_region.attribute_02;
    c_percent_column constant varchar2(255) := p_region.attribute_03;
    c_link_target    constant varchar2(255) := p_region.attribute_04;
  
    c_layout     constant varchar2(1) := p_region.attribute_05;
    c_chart_size constant varchar2(3) := p_region.attribute_06;
    c_chart_type constant varchar2(3) := p_region.attribute_07;
    c_colored    constant varchar2(1) := p_region.attribute_08;
  
    l_label_column_no   pls_integer;
    l_value_column_no   pls_integer;
    l_percent_column_no pls_integer;
    l_column_value_list apex_plugin_util.t_column_value_list2;
  
    l_label   varchar2(4000);
    l_value   varchar2(4000);
    l_percent number;
    l_url     varchar2(4000);
    l_class   varchar2(255);
  
  begin
    apex_json.initialize_output(p_http_cache => false);
    -- Read the data based on the region source query
    l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => p_region.source,
                                                      p_min_columns    => 2,
                                                      p_max_columns    => null,
                                                      p_component_name => p_region.name);
  
    -- Get the actual column# for faster access and also verify that the data type
    -- of the column matches with what we are looking for
    l_label_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Label Column',
                                                        p_column_alias      => c_label_column,
                                                        p_column_value_list => l_column_value_list,
                                                        p_is_required       => true,
                                                        p_data_type         => apex_plugin_util.c_data_type_varchar2);
  
    l_value_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Value Column',
                                                        p_column_alias      => c_value_column,
                                                        p_column_value_list => l_column_value_list,
                                                        p_is_required       => true,
                                                        p_data_type         => apex_plugin_util.c_data_type_varchar2);
  
    l_percent_column_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Percent Column',
                                                          p_column_alias      => c_percent_column,
                                                          p_column_value_list => l_column_value_list,
                                                          p_is_required       => false,
                                                          p_data_type         => apex_plugin_util.c_data_type_number);
  
    -- begin output as json
    owa_util.mime_header('application/json', false);
    htp.p('cache-control: no-cache');
    htp.p('pragma: no-cache');
    owa_util.http_header_close;
    --   l_message_when_no_data_found := apex_escape.html_whitelist(
    --      apex_plugin_util.replace_substitutions (
    --             p_value  => c_message_when_no_data_found,
    --             p_escape => false
    --        )
    --    );
    apex_json.open_object();
    apex_json.write('layout', c_layout);
    apex_json.write('chart_size', c_chart_size);
    apex_json.write('chart_type', c_chart_type);
    apex_json.write('colored', c_colored);
    apex_json.open_array('data');
    for l_row_num in 1 .. l_column_value_list(1).value_list.count loop
      begin
        apex_json.open_object();
        -- Set the column values of our current row so that apex_plugin_util.replace_substitutions
        -- can do substitutions for columns contained in the region source query.
        apex_plugin_util.set_component_values(p_column_value_list => l_column_value_list,
                                              p_row_num           => l_row_num);
      
        -- get the label
        l_label := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_label_column_no)
                                                                         .data_type,
                                                          p_value     => l_column_value_list(l_label_column_no)
                                                                         .value_list(l_row_num));
        --  p_region.escape_output );apex_plugin_util.escape (
      
        apex_json. write('label', l_label);
      
        -- get the value
        l_value := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_value_column_no)
                                                                         .data_type,
                                                          p_value     => l_column_value_list(l_value_column_no)
                                                                         .value_list(l_row_num));
      
        apex_json. write('value', l_value);
      
        -- get percent
        if l_percent_column_no is not null then
          l_percent := l_column_value_list(l_percent_column_no).value_list(l_row_num)
                       .number_value;
          apex_json. write('percent', l_percent);
        end if;
      
        -- get the link target if it does exist
        if c_link_target is not null then
          l_url := apex_util.prepare_url(apex_plugin_util.replace_substitutions(p_value  => c_link_target,
                                                                                p_escape => false));
          apex_json. write('url', l_url);
        end if;
      
        apex_json.close_object();
      
        apex_plugin_util.clear_component_values;
      exception
        when others then
          apex_plugin_util.clear_component_values;
          raise;
      end;
    end loop;
    apex_json.close_all();
  
    return null;
  exception
    when others then
      htp.p('error: ' || apex_escape.html(sqlerrm));
      return null;
  end ajax_badge;

  function f_ajax_old(p_region in apex_plugin.t_region,
                      p_plugin in apex_plugin.t_plugin)
    return apex_plugin.t_region_ajax_result is
    l_ajax_result apex_plugin.t_region_ajax_result;
  
    atr_col_span APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_03,
                                                                              ',');
  
    atr_height APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_04,
                                                                            ',');
  
    atr_hdr_bkgrnd_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_05,
                                                                                      ',');
  
    atr_hdr_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_06,
                                                                                    ',');
  
    atr_hdr_font_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_07,
                                                                                   ',');
  
    atr_card_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_08,
                                                                                ',');
    atr_text_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_09,
                                                                                ',');
  
    atr_text_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_10,
                                                                               ',');
  
    atr_ftr_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_11,
                                                                                    ',');
  
    atr_ftr_font_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_12,
                                                                                   ',');
  
    /* atr_hdr_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_06,
                                                                                    ',');
    
    atr_hdr_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_06,
                                                                                    ',');
    */
  
    --Options for the plugin
    ---------------------------------------
    -- v_Options clob;
  
    l_arr_lst APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_val     varchar2(32767);
  
    l_tk  APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_opt APEX_APPLICATION_GLOBAL.VC_ARR2;
  
    TYPE ass_tab IS TABLE OF VARCHAR2(100);
    aar_opts   ass_tab;
    aar_sels   ass_tab := ass_tab();
    aar_unsels ass_tab := ass_tab();
    l_idx      Integer;
  
    -- code variables
    -------------------
    l_html    varchar2(32767);
    l_js_code varchar2(32767);
  
    l_crlf char(2) := chr(13) || chr(10);
  
    --LIST QUERY
    --==========================================
    -- It's better to have named variables instead of using the generic ones,
    -- makes the code more readable. We are using the same defaults for the
    -- required attributes as in the plug-in attribute configuration, because
    -- they can still be null. Keep them in sync!
    c_title_column  constant varchar2(255) := p_region.attribute_13;
    c_value_column  constant varchar2(255) := p_region.attribute_14;
    c_symbol_column constant varchar2(255) := p_region.attribute_15;
    c_trend_column  constant varchar2(255) := p_region.attribute_16;
    c_footer_column constant varchar2(255) := p_region.attribute_17;
    c_link_target   constant varchar2(255) := p_region.attribute_18;
  
    l_title_column_no  pls_integer;
    l_value_column_no  pls_integer;
    l_symbol_column_no pls_integer;
    l_trend_column_no  pls_integer;
    l_footer_column_no pls_integer;
    l_url_column_no    pls_integer;
  
    l_column_value_list apex_plugin_util.t_column_value_list2;
  
    l_title  varchar2(32767);
    l_value  Number(14);
    l_trend  varchar2(4);
    l_symbol varchar2(4);
    l_footer varchar2(32767);
  
    l_query              clob;
    l_lst_type           varchar2(50);
    l_col_data_type_list apex_application_global.vc_arr2;
    l_col_val_list       apex_plugin_util.t_column_value_list2;
  
  begin
  
    apex_plugin_util.print_json_http_header;
    apex_json.initialize_output(p_http_cache => false);
    -- begin output as json
    /* owa_util.mime_header('application/json', false);
    htp.p('cache-control: no-cache');
    htp.p('pragma: no-cache');
    owa_util.http_header_close; */
  
    apex_json.open_object; --{
    apex_json.open_array('cards');
  
    -- Read the data based on the region source query
    -- In the query
    -- the first column is the title(null or '...' and string
    -- the 2nd column is the percentage value(0 or greater) and number
    -- the 3rd column is the Target percentage value(0 or greater) and number
    -- the 4th column is the font awesome icon(null or icon name) and string
  
    /* l_col_data_type_list(g_title_col) := apex_plugin_util.c_data_type_varchar2;
    l_col_data_type_list(g_value_col) := apex_plugin_util.c_data_type_number;
    l_col_data_type_list(g_trend_col) := apex_plugin_util.c_data_type_varchar2;
    l_col_data_type_list(g_symbol_col) := apex_plugin_util.c_data_type_varchar2;
    l_col_data_type_list(g_footer_col) := apex_plugin_util.c_data_type_varchar2;*/
  
    -- Read the data based on the region source query
    l_col_val_list := apex_plugin_util.get_data2(p_sql_statement  => p_region.source,
                                                 p_min_columns    => 2,
                                                 p_max_columns    => 5,
                                                 p_data_type_list => l_col_data_type_list,
                                                 p_component_name => p_region.name);
  
    /*apex_application.show_error_message(p_message => 'this',
    p_footer  => l_col_val_list(l_col_val_list.first).value_list.count
    );*/
    For i in 1 .. l_col_val_list(l_col_val_list.first).value_list.count loop
      l_title  := null;
      l_value  := 0;
      l_symbol := null;
      l_trend  := '';
      l_footer := null;
    
      -- Set the column values of our current row so that apex_plugin_util.replace_substitutions
      -- can do substitutions for columns contained in the region source query.
      apex_plugin_util.set_component_values(p_column_value_list => l_col_val_list,
                                            p_row_num           => i);
    
      ---Template--
      --=======================
      apex_json.open_object;
      apex_json.write('colSpan',
                      case when atr_col_span.exists(i) AND
                      atr_col_span(i) is NOT NULL AND
                      TO_NUMBER(atr_col_span(i)) between 1 and 12 then
                      atr_col_span(i) else 3 end);
    
      --==Query Columns and Main Values==---
      ---------------------------------
      l_title := sys.htf.escape_sc(l_col_val_list(g_title_col).value_list(i)
                                   .varchar2_value);
    
      l_value := sys.htf.escape_sc(l_col_val_list(g_value_col).value_list(i)
                                   .number_value);
    
      if l_col_val_list.exists(g_trend_col) then
        l_trend := sys.htf.escape_sc(l_col_val_list(g_trend_col).value_list(i)
                                     .varchar2_value);
      end if;
    
      if l_col_val_list.exists(g_symbol_col) and l_col_val_list(g_symbol_col).value_list(i)
        .varchar2_value is not null then
        l_symbol := sys.htf.escape_sc(l_col_val_list(g_symbol_col).value_list(i)
                                      .varchar2_value);
      
      end if;
    
      if l_col_val_list.exists(g_footer_col) then
        l_footer := sys.htf.escape_sc(l_col_val_list(g_footer_col).value_list(i)
                                      .varchar2_value);
      end if;
    
      apex_json.write('title', l_title);
      apex_json.write('footer', l_footer);
    
      apex_json.open_object('data');
      apex_json.write('value', l_value);
      apex_json.write('trend', l_trend);
      apex_json.write('symbol', l_symbol);
      apex_json.close_object;
    
      --End "Query Columns and Main Values"
      -------------------------------------------------------
    
      apex_json.write('height',
                      case when atr_height.exists(i) then atr_height(i) end);
    
      apex_json.write('headerColor',
                      case when atr_hdr_bkgrnd_color.exists(i) then
                      atr_hdr_bkgrnd_color(i) end);
    
      apex_json.write('headerFontColor',
                      case when atr_hdr_font_color.exists(i) then
                      atr_hdr_font_color(i) end);
    
      apex_json.write('headerFontSize',
                      case when atr_hdr_font_size.exists(i) then
                      atr_hdr_font_size(i) end);
    
      apex_json.write('cardColor',
                      case when atr_card_color.exists(i) then
                      atr_card_color(i) end);
    
      apex_json.write('cardTextColor',
                      case when atr_text_color.exists(i) then
                      atr_text_color(i) end);
    
      apex_json.write('cardTextSize',
                      case when atr_text_size.exists(i) then
                      atr_text_size(i) end);
    
      apex_json.write('FooterTextColor',
                      case when atr_ftr_font_color.exists(i) then
                      atr_ftr_font_color(i) end);
    
      apex_json.write('FooterTextSize',
                      case when atr_ftr_font_size.exists(i) then
                      atr_ftr_font_size(i) end);
    
      /*
      Options in the plugin have display values for options e,g toggleSelected','autoClose','keyboardNav'
      with return values as 1,2,3,4....
      Here the aar_opts is populated with the actula JS option for the corresponding Plugin Display Option value
      so their index 1,2,3 ….. are synced
      */
      /*  aar_opts := ass_tab('textBelow',
      'animation',
      'animateInView',
      'alwaysDecimals',
      'showPercent',
      'noPercentageSign',
      'multiPercentage');*/
      --populate the selected options in the aar_sels varray, since atr_Options(i)[plugin opt attr] will return
      --the return values of the selected as ,2,5,8....
      --So the aar_opts(2) = autoClose ,  aar_opts(5) = clearButton
    
      /*  FOR i IN 1 .. atr_Options.count LOOP
        aar_sels.extend;
      
        aar_sels(i) := aar_opts(to_NUMBER(atr_Options(i)));
      END LOOP;
      aar_unsels := aar_opts MULTISET except aar_sels;
      
      l_idx := aar_sels.first;
      while (l_idx is not null) loop
        IF aar_sels(l_idx) = 'animation' OR aar_sels(l_idx) = 'showPercent' OR
           aar_sels(l_idx) = 'multiPercentage' then
          apex_json.write(aar_sels(l_idx), 1);
        ELSE
          apex_json.write(aar_sels(l_idx), true);
        ENd If;
        l_idx := aar_sels.next(l_idx);
      end loop;
      l_idx := aar_unsels.first;
      while (l_idx is not null) loop
        IF aar_unsels(l_idx) in
           ('animation', 'showPercent', 'multiPercentage') then
          apex_json.write(aar_unsels(l_idx), 0);
        ELSE
          apex_json.write(aar_unsels(l_idx), false);
        ENd If;
      
        l_idx := aar_unsels.next(l_idx);
      end loop;*/
    
      apex_json.close_object;
    End loop;
  
    apex_json.close_array;
  
    apex_json.write('pageItems',
                    apex_plugin_util.page_item_names_to_jquery(p_region.ajax_items_to_submit));
  
    apex_json.close_object;
  
    apex_plugin_util.clear_component_values;
  
    return null;
  exception
    when others then
      htp.p('error: ' || apex_escape.html(sqlerrm));
      return null;
  end f_ajax_old;

  function f_ajax1(p_region in apex_plugin.t_region,
                   p_plugin in apex_plugin.t_plugin)
    return apex_plugin.t_region_ajax_result is
    l_ajax_result apex_plugin.t_region_ajax_result;
  
    --Options for the plugin
    ---------------------------------------
    -- v_Options clob;
    v_Options varchar2(32767); --Options per Chart
    l_arr_lst APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_val     varchar2(32767);
  
    --LIST QUERY
    l_title   varchar2(32767);
    l_percent Number(14);
    l_target  Number(14);
    l_icon    varchar2(32767);
  
    l_query              clob;
    l_lst_type           varchar2(50);
    l_col_data_type_list apex_application_global.vc_arr2;
    l_col_val_list       apex_plugin_util.t_column_value_list2;
  
    -- code variables
    -------------------
    l_html    varchar2(32767);
    l_js_code varchar2(32767);
  
  begin
  
    apex_json.initialize_output(p_http_cache => false);
  
    -- begin output as json
    owa_util.mime_header('application/json', false);
    htp.p('cache-control: no-cache');
    htp.p('pragma: no-cache');
    owa_util.http_header_close;
  
    apex_json.open_object(); --{
  
    apex_json.open_array('chart');
  
    -- Read the data based on the region source query
    -- In the query
    -- the first column is the title(null or '...' and string
    -- the 2nd column is the percentage value(0 or greater) and number
    -- the 3rd column is the Target percentage value(0 or greater) and number
    -- the 4th column is the font awesome icon(null or icon name) and string
  
    l_col_data_type_list(g_title_col) := apex_plugin_util.c_data_type_varchar2;
    l_col_data_type_list(g_value_col) := apex_plugin_util.c_data_type_number;
    l_col_data_type_list(g_trend_col) := apex_plugin_util.c_data_type_number;
    l_col_data_type_list(g_symbol_col) := apex_plugin_util.c_data_type_varchar2;
    --
  
    l_col_val_list := apex_plugin_util.get_data2(p_sql_statement  => p_region.source,
                                                 p_min_columns    => 2,
                                                 p_max_columns    => 5,
                                                 p_data_type_list => l_col_data_type_list,
                                                 p_component_name => p_region.name);
  
    l_js_code := '';
  
    /*apex_application.show_error_message(p_message => 'this',
    p_footer  => l_col_val_list(l_col_val_list.first).value_list.count
    );*/
    For i in 1 .. l_col_val_list(l_col_val_list.first).value_list.count loop
      v_Options := '';
    
      apex_plugin_util.set_component_values(p_column_value_list => l_col_val_list,
                                            p_row_num           => i);
      apex_json.open_object(); --{
    
      --==Query Columns and Main Values==---
      ---------------------------------
      l_title := sys.htf.escape_sc(l_col_val_list(g_title_col).value_list(i)
                                   .varchar2_value);
    
      l_percent := sys.htf.escape_sc(l_col_val_list(g_value_col).value_list(i)
                                     .number_value);
    
      if l_col_val_list.exists(g_trend_col) then
        l_target := sys.htf.escape_sc(l_col_val_list(g_trend_col).value_list(i)
                                      .number_value);
      end if;
    
      if l_col_val_list.exists(g_symbol_col) and l_col_val_list(g_symbol_col).value_list(i)
        .varchar2_value is not null then
        l_icon := sys.htf.escape_sc(l_col_val_list(g_symbol_col).value_list(i)
                                    .varchar2_value);
      
      end if;
    
      apex_json.write('text', l_title);
      apex_json.write('percent', l_percent);
      apex_json.write('targetPercent', l_target);
      apex_json.write('iconFA', l_icon);
    
      --End "Query Columns and Main Values"
      -------------------------------------------------------
    
      apex_json.close_object();
    
    End loop;
  
    apex_json.close_array;
    apex_json.close_object;
    --- apex_json.close_all();
  
    apex_plugin_util.clear_component_values;
  
    --return l_ajax_result;
    return null;
  exception
    when others then
      htp.p('error: ' || apex_escape.html(sqlerrm));
      return null;
  end f_ajax1;

  function f_render_guage(p_region              in apex_plugin.t_region,
                          p_plugin              in apex_plugin.t_plugin,
                          p_is_printer_friendly in boolean)
    return apex_plugin.t_region_render_result is
    l_render_result apex_plugin.t_region_render_result;
  
    -- Region Plugin Attributes
    -----------------------------------------
    subtype attr is p_region.attribute_01%type;
  
    -- atr_start_row boolean := f_yn_2_truefalse(p_region.attribute_0);
    atr_col_span      APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_01,
                                                                                   ',');
    atr_templ         INTEGER := TO_NUMBER(p_region.attribute_02);
    atr_title_color   APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_03,
                                                                                   ',');
    atr_title_style   APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_04,
                                                                                   '^*^');
    atr_title_XY      APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_05,
                                                                                   ',');
    atr_title_curr_XY APEX_APPLICATION_GLOBAL.VC_ARR2;
  
    atr_animation_step APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_06,
                                                                                    ',');
  
    atr_perc_txt_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_07,
                                                                                   ',');
  
    atr_perc_XY_pos APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_08,
                                                                                 ',');
  
    atr_perc_curr_XY_pos APEX_APPLICATION_GLOBAL.VC_ARR2;
  
    atr_half_circle APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_09,
                                                                                 ',');
  
    atr_perc_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_10,
                                                                                     ',');
    atr_perc_decimals   APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_11,
                                                                                     ',');
    atr_targ_font_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_12,
                                                                                     ',');
  
    atr_targ_font_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_13,
                                                                                    ',');
  
    atr_icon APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_14,
                                                                          ',');
  
    atr_icon_size APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_15,
                                                                               ',');
  
    atr_icon_color APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_16,
                                                                                ',');
  
    atr_icon_position APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_17,
                                                                                   ',');
  
    atr_circ_perc_size         APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_18,
                                                                                            ',');
    atr_circ_perc_color        APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_19,
                                                                                            ',');
    atr_circ_perc_outer_color  APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_20,
                                                                                            ',');
    atr_circ_main_color        APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_21,
                                                                                            ',');
    atr_circ_main_border_width APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_22,
                                                                                            ',');
    atr_perc_circum_seg_color  APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_23,
                                                                                            ',');
    atr_perc_circum_seg_width  APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_24,
                                                                                            ',');
    atr_Options                APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(p_region.attribute_25,
                                                                                            ':');
  
    --Options for the plugin
    ---------------------------------------
    v_Options clob;
    l_arr_lst APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_val     varchar2(32767);
  
    l_tk  APEX_APPLICATION_GLOBAL.VC_ARR2;
    l_opt APEX_APPLICATION_GLOBAL.VC_ARR2;
  
    TYPE ass_tab IS TABLE OF VARCHAR2(100);
    aar_opts   ass_tab;
    aar_sels   ass_tab := ass_tab();
    aar_unsels ass_tab := ass_tab();
    l_idx      Integer;
  
    --LIST QUERY
    l_title   varchar2(32767);
    l_percent Number(14);
    l_target  Number(14);
    l_icon    varchar2(32767);
  
    l_query              clob;
    l_lst_type           varchar2(50);
    l_col_data_type_list apex_application_global.vc_arr2;
    l_col_val_list       apex_plugin_util.t_column_value_list2;
  
    -- font Awesome Icons
    ----------------------------------
    TYPE fontAwesome IS TABLE OF VARCHAR2(5) INDEX BY VARCHAR2(30);
    fa_list fontAwesome;
    icon    VARCHAR2(30);
  
    -- code variables
    -------------------
    l_html    varchar2(32767);
    l_js_code varchar2(32767);
    l_regTemp varchar2(32767) := case
                                   when atr_templ in (2, 3) then
                                    '<div class="col col-%COL_SPAN%">
            <div class="t-Region t-Region--scrollBody" role="group" aria-labelledby="' ||
                                    apex_escape.html_attribute(p_region.static_id ||
                                                               '_chart') ||
                                    '_heading">
             %TITLE_TEMPL%
             <div class="t-Region-bodyWrap">
             <div class="t-Region-body">'
                                   Else
                                    '<div class="col col-%COL_SPAN%">'
                                 end;
  
    l_reg_Temp_Header varchar2(32767) := '<div class="t-Region-header">
                        <div class="t-Region-headerItems t-Region-headerItems--title">
                            <h2 class="t-Region-title" id="' ||
                                         apex_escape.html_attribute(p_region.static_id ||
                                                                    '_chart') ||
                                         '_heading">%REG_TITLE%</h2>
                        </div>
                    </div>';
    l_regStart        varchar2(32767);
  
    l_regTitle varchar2(32767) := 'New';
  
    l_regEnd varchar2(32767) := case
                                  when atr_templ in (2, 3) then
                                   '</div></div></div></div>'
                                  else
                                   '</div>'
                                
                                end;
  
  begin
    /*  apex_javascript.add_library(p_name           => 'jquery.circliful',
    p_directory      => apex_application.g_image_prefix ||
                        'libraries/circa/js/',
    p_version        => null,
    p_skip_extension => FALSE);*/
  
    /*  apex_css.add_file(p_name      => 'material-design-iconic-font.min',
                     p_directory => apex_application.g_image_prefix ||
                                    'libraries/circa/css/');
    */
    apex_css.add_file(p_name      => 'jquery.circliful',
                      p_directory => apex_application.g_image_prefix ||
                                     'libraries/circa/css/');
  
    ---Source Content Generation
    --=======================================================================
    -- Populating PL SQL table with Unicodes
    fa_list('glass') := 'f000';
    fa_list('music') := 'f001';
    fa_list('search') := 'f002';
    fa_list('envelope-o') := 'f003';
    fa_list('heart') := 'f004';
    fa_list('star') := 'f005';
    fa_list('star-o') := 'f006';
    fa_list('user') := 'f007';
    fa_list('film') := 'f008';
    fa_list('th-large') := 'f009';
    fa_list('th') := 'f00a';
    fa_list('th-list') := 'f00b';
    fa_list('check') := 'f00c';
    fa_list('remove') := 'f00d';
    fa_list('close') := 'f00d';
    fa_list('times') := 'f00d';
    fa_list('search-plus') := 'f00e';
    fa_list('search-minus') := 'f010';
    fa_list('power-off') := 'f011';
    fa_list('signal') := 'f012';
    fa_list('gear') := 'f013';
    fa_list('cog') := 'f013';
    fa_list('trash-o') := 'f014';
    fa_list('home') := 'f015';
    fa_list('file-o') := 'f016';
    fa_list('clock-o') := 'f017';
    fa_list('road') := 'f018';
    fa_list('download') := 'f019';
    fa_list('arrow-circle-o-down') := 'f01a';
    fa_list('arrow-circle-o-up') := 'f01b';
    fa_list('inbox') := 'f01c';
    fa_list('play-circle-o') := 'f01d';
    fa_list('rotate-right') := 'f01e';
    fa_list('repeat') := 'f01e';
    fa_list('refresh') := 'f021';
    fa_list('list-alt') := 'f022';
    fa_list('lock') := 'f023';
    fa_list('flag') := 'f024';
    fa_list('headphones') := 'f025';
    fa_list('volume-off') := 'f026';
    fa_list('volume-down') := 'f027';
    fa_list('volume-up') := 'f028';
    fa_list('qrcode') := 'f029';
    fa_list('barcode') := 'f02a';
    fa_list('tag') := 'f02b';
    fa_list('tags') := 'f02c';
    fa_list('book') := 'f02d';
    fa_list('bookmark') := 'f02e';
    fa_list('print') := 'f02f';
    fa_list('camera') := 'f030';
    fa_list('font') := 'f031';
    fa_list('bold') := 'f032';
    fa_list('italic') := 'f033';
    fa_list('text-height') := 'f034';
    fa_list('text-width') := 'f035';
    fa_list('align-left') := 'f036';
    fa_list('align-center') := 'f037';
    fa_list('align-right') := 'f038';
    fa_list('align-justify') := 'f039';
    fa_list('list') := 'f03a';
    fa_list('dedent') := 'f03b';
    fa_list('outdent') := 'f03b';
    fa_list('indent') := 'f03c';
    fa_list('video-camera') := 'f03d';
    fa_list('photo') := 'f03e';
    fa_list('image') := 'f03e';
    fa_list('picture-o') := 'f03e';
    fa_list('pencil') := 'f040';
    fa_list('map-marker') := 'f041';
    fa_list('adjust') := 'f042';
    fa_list('tint') := 'f043';
    fa_list('edit') := 'f03e';
    fa_list('pencil-square-o') := 'f044';
    fa_list('share-square-o') := 'f045';
    fa_list('check-square-o') := 'f046';
    fa_list('arrows') := 'f047';
    fa_list('step-backward') := 'f048';
    fa_list('fast-backward') := 'f049';
    fa_list('backward') := 'f04a';
    fa_list('play') := 'f04b';
    fa_list('pause') := 'f04c';
    fa_list('stop') := 'f04d';
    fa_list('forward') := 'f04e';
    fa_list('fast-forward') := 'f050';
    fa_list('step-forward') := 'f051';
    fa_list('eject') := 'f052';
    fa_list('chevron-left') := 'f053';
    fa_list('chevron-right') := 'f054';
    fa_list('plus-circle') := 'f055';
    fa_list('minus-circle') := 'f056';
    fa_list('times-circle') := 'f057';
    fa_list('check-circle') := 'f058';
    fa_list('question-circle') := 'f059';
    fa_list('info-circle') := 'f05a';
    fa_list('crosshairs') := 'f05b';
    fa_list('times-circle-o') := 'f05c';
    fa_list('check-circle-o') := 'f05d';
    fa_list('ban') := 'f05e';
    fa_list('arrow-left') := 'f060';
    fa_list('arrow-right') := 'f061';
    fa_list('arrow-up') := 'f062';
    fa_list('arrow-down') := 'f063';
    fa_list('mail-forward') := 'f064';
    fa_list('share') := 'f064';
    fa_list('expand') := 'f065';
    fa_list('compress') := 'f066';
    fa_list('plus') := 'f067';
    fa_list('minus') := 'f068';
    fa_list('asterisk') := 'f069';
    fa_list('exclamation-circle') := 'f06a';
    fa_list('gift') := 'f06b';
    fa_list('leaf') := 'f06c';
    fa_list('fire') := 'f06d';
    fa_list('eye') := 'f06e';
    fa_list('eye-slash') := 'f070';
    fa_list('warning') := 'f071';
    fa_list('exclamation-triangle') := 'f071';
    fa_list('plane') := 'f072';
    fa_list('calendar') := 'f073';
    fa_list('random') := 'f074';
    fa_list('comment') := 'f075';
    fa_list('magnet') := 'f076';
    fa_list('chevron-up') := 'f077';
    fa_list('chevron-down') := 'f078';
    fa_list('retweet') := 'f079';
    fa_list('shopping-cart') := 'f07a';
    fa_list('folder') := 'f07b';
    fa_list('folder-open') := 'f07c';
    fa_list('arrows-v') := 'f07d';
    fa_list('arrows-h') := 'f07e';
    fa_list('bar-chart-o') := 'f080';
    fa_list('bar-chart') := 'f080';
    fa_list('twitter-square') := 'f081';
    fa_list('facebook-square') := 'f082';
    fa_list('camera-retro') := 'f083';
    fa_list('key') := 'f084';
    fa_list('gears') := 'f085';
    fa_list('cogs') := 'f085';
    fa_list('comments') := 'f086';
    fa_list('thumbs-o-up') := 'f087';
    fa_list('thumbs-o-down') := 'f088';
    fa_list('star-half') := 'f089';
    fa_list('heart-o') := 'f08a';
    fa_list('sign-out') := 'f08b';
    fa_list('linkedin-square') := 'f08c';
    fa_list('thumb-tack') := 'f08d';
    fa_list('external-link') := 'f08e';
    fa_list('sign-in') := 'f090';
    fa_list('trophy') := 'f091';
    fa_list('github-square') := 'f092';
    fa_list('upload') := 'f093';
    fa_list('lemon-o') := 'f094';
    fa_list('phone') := 'f095';
    fa_list('square-o') := 'f096';
    fa_list('bookmark-o') := 'f097';
    fa_list('phone-square') := 'f098';
    fa_list('twitter') := 'f099';
    fa_list('facebook') := 'f09a';
    fa_list('github') := 'f09b';
    fa_list('unlock') := 'f09c';
    fa_list('credit-card') := 'f09d';
    fa_list('rss') := 'f09e';
    fa_list('hdd-o') := 'f0a0';
    fa_list('bullhorn') := 'f0a1';
    fa_list('bell') := 'f0f3';
    fa_list('certificate') := 'f0a3';
    fa_list('hand-o-right') := 'f0a4';
    fa_list('hand-o-left') := 'f0a5';
    fa_list('hand-o-up') := 'f0a6';
    fa_list('hand-o-down') := 'f0a7';
    fa_list('arrow-circle-left') := 'f0a8';
    fa_list('arrow-circle-right') := 'f0a9';
    fa_list('arrow-circle-up') := 'f0aa';
    fa_list('arrow-circle-down') := 'f0ab';
    fa_list('globe') := 'f0ac';
    fa_list('wrench') := 'f0ad';
    fa_list('tasks') := 'f0ae';
    fa_list('filter') := 'f0b0';
    fa_list('briefcase') := 'f0b1';
    fa_list('arrows-alt') := 'f0b2';
    fa_list('group') := 'f0c0';
    fa_list('users') := 'f0c0';
    fa_list('chain') := 'f0c1';
    fa_list('link') := 'f0c1';
    fa_list('cloud') := 'f0c2';
    fa_list('flask') := 'f0c3';
    fa_list('cut') := 'f0c4';
    fa_list('scissors') := 'f0c4';
    fa_list('copy') := 'f0c5';
    fa_list('files-o') := 'f0c5';
    fa_list('paperclip') := 'f0c6';
    fa_list('save') := 'f0c7';
    fa_list('floppy-o') := 'f0c7';
    fa_list('square') := 'f0c8';
    fa_list('navicon') := 'f0c9';
    fa_list('reorder') := 'f0c9';
    fa_list('bars') := 'f0c9';
    fa_list('list-ul') := 'f0ca';
    fa_list('list-ol') := 'f0cb';
    fa_list('strikethrough') := 'f0cc';
    fa_list('underline') := 'f0cd';
    fa_list('table') := 'f0ce';
    fa_list('magic') := 'f0d0';
    fa_list('truck') := 'f0d1';
    fa_list('pinterest') := 'f0d2';
    fa_list('pinterest-square') := 'f0d3';
    fa_list('google-plus-square') := 'f0d4';
    fa_list('google-plus') := 'f0d5';
    fa_list('money') := 'f0d6';
    fa_list('caret-down') := 'f0d7';
    fa_list('caret-up') := 'f0d8';
    fa_list('caret-left') := 'f0d9';
    fa_list('caret-right') := 'f0da';
    fa_list('columns') := 'f0db';
    fa_list('unsorted') := 'f0dc';
    fa_list('sort') := 'f0dc';
    fa_list('sort-down') := 'f0dd';
    fa_list('sort-desc') := 'f0dd';
    fa_list('sort-up') := 'f0de';
    fa_list('sort-asc') := 'f0de';
    fa_list('envelope') := 'f0e0';
    fa_list('linkedin') := 'f0e1';
    fa_list('rotate-left') := 'f0e2';
    fa_list('undo') := 'f0e2';
    fa_list('legal') := 'f0e3';
    fa_list('gavel') := 'f0e3';
    fa_list('dashboard') := 'f0e4';
    fa_list('tachometer') := 'f0e4';
    fa_list('comment-o') := 'f0e5';
    fa_list('comments-o') := 'f0e6';
    fa_list('flash') := 'f0e7';
    fa_list('bolt') := 'f0e7';
    fa_list('sitemap') := 'f0e8';
    fa_list('umbrella') := 'f0e9';
    fa_list('paste') := 'f0ea';
    fa_list('clipboard') := 'f0ea';
    fa_list('lightbulb-o') := 'f0eb';
    fa_list('exchange') := 'f0ec';
    fa_list('cloud-download') := 'f0ed';
    fa_list('cloud-upload') := 'f0ee';
    fa_list('user-md') := 'f0f0';
    fa_list('stethoscope') := 'f0f1';
    fa_list('suitcase') := 'f0f2';
    fa_list('bell-o') := 'f0a2';
    fa_list('coffee') := 'f0f4';
    fa_list('cutlery') := 'f0f5';
    fa_list('file-text-o') := 'f0f6';
    fa_list('building-o') := 'f0f7';
    fa_list('hospital-o') := 'f0f8';
    fa_list('ambulance') := 'f0f9';
    fa_list('medkit') := 'f0fa';
    fa_list('fighter-jet') := 'f0fb';
    fa_list('beer') := 'f0fc';
    fa_list('h-square') := 'f0fd';
    fa_list('plus-square') := 'f0fe';
    fa_list('angle-double-left') := 'f100';
    fa_list('angle-double-right') := 'f101';
    fa_list('angle-double-up') := 'f102';
    fa_list('angle-double-down') := 'f103';
    fa_list('angle-left') := 'f104';
    fa_list('angle-right') := 'f105';
    fa_list('angle-up') := 'f106';
    fa_list('angle-down') := 'f107';
    fa_list('desktop') := 'f108';
    fa_list('laptop') := 'f109';
    fa_list('tablet') := 'f10a';
    fa_list('mobile-phone') := 'f10b';
    fa_list('mobile') := 'f10b';
    fa_list('circle-o') := 'f10c';
    fa_list('quote-left') := 'f10d';
    fa_list('quote-right') := 'f10e';
    fa_list('spinner') := 'f110';
    fa_list('circle') := 'f111';
    fa_list('mail-reply') := 'f112';
    fa_list('reply') := 'f112';
    fa_list('github-alt') := 'f113';
    fa_list('folder-o') := 'f114';
    fa_list('folder-open-o') := 'f115';
    fa_list('smile-o') := 'f118';
    fa_list('frown-o') := 'f119';
    fa_list('meh-o') := 'f11a';
    fa_list('gamepad') := 'f11b';
    fa_list('keyboard-o') := 'f11c';
    fa_list('flag-o') := 'f11d';
    fa_list('flag-checkered') := 'f11e';
    fa_list('terminal') := 'f120';
    fa_list('code') := 'f121';
    fa_list('mail-reply-all') := 'f122';
    fa_list('reply-all') := 'f122';
    fa_list('star-half-empty') := 'f123';
    fa_list('star-half-full') := 'f123';
    fa_list('star-half-o') := 'f123';
    fa_list('location-arrow') := 'f124';
    fa_list('crop') := 'f125';
    fa_list('code-fork') := 'f126';
    fa_list('unlink') := 'f127';
    fa_list('chain-broken') := 'f127';
    fa_list('question') := 'f128';
    fa_list('info') := 'f129';
    fa_list('exclamation') := 'f12a';
    fa_list('superscript') := 'f12b';
    fa_list('subscript') := 'f12c';
    fa_list('eraser') := 'f12d';
    fa_list('puzzle-piece') := 'f12e';
    fa_list('microphone') := 'f130';
    fa_list('microphone-slash') := 'f131';
    fa_list('shield') := 'f132';
    fa_list('calendar-o') := 'f133';
    fa_list('fire-extinguisher') := 'f134';
    fa_list('rocket') := 'f135';
    fa_list('maxcdn') := 'f136';
    fa_list('chevron-circle-left') := 'f137';
    fa_list('chevron-circle-right') := 'f138';
    fa_list('chevron-circle-up') := 'f139';
    fa_list('chevron-circle-down') := 'f13a';
    fa_list('html5') := 'f13b';
    fa_list('css3') := 'f13c';
    fa_list('anchor') := 'f13d';
    fa_list('unlock-alt') := 'f13e';
    fa_list('bullseye') := 'f140';
    fa_list('ellipsis-h') := 'f141';
    fa_list('ellipsis-v') := 'f142';
    fa_list('rss-square') := 'f143';
    fa_list('play-circle') := 'f144';
    fa_list('ticket') := 'f145';
    fa_list('minus-square') := 'f146';
    fa_list('minus-square-o') := 'f147';
    fa_list('level-up') := 'f148';
    fa_list('level-down') := 'f149';
    fa_list('check-square') := 'f14a';
    fa_list('pencil-square') := 'f14b';
    fa_list('external-link-square') := 'f14c';
    fa_list('share-square') := 'f14d';
    fa_list('compass') := 'f14e';
    fa_list('toggle-down') := 'f150';
    fa_list('caret-square-o-down') := 'f150';
    fa_list('toggle-up') := 'f151';
    fa_list('caret-square-o-up') := 'f151';
    fa_list('toggle-right') := 'f152';
    fa_list('caret-square-o-right') := 'f152';
    fa_list('euro') := 'f153';
    fa_list('eur') := 'f153';
    fa_list('gbp') := 'f154';
    fa_list('dollar') := 'f155';
    fa_list('usd') := 'f155';
    fa_list('rupee') := 'f156';
    fa_list('inr') := 'f156';
    fa_list('cny') := 'f157';
    fa_list('rmb') := 'f157';
    fa_list('yen') := 'f157';
    fa_list('jpy') := 'f157';
    fa_list('ruble') := 'f158';
    fa_list('rouble') := 'f158';
    fa_list('rub') := 'f158';
    fa_list('won') := 'f159';
    fa_list('krw') := 'f159';
    fa_list('bitcoin') := 'f15a';
    fa_list('btc') := 'f15a';
    fa_list('file') := 'f15b';
    fa_list('file-text') := 'f15c';
    fa_list('sort-alpha-asc') := 'f15d';
    fa_list('sort-alpha-desc') := 'f15e';
    fa_list('sort-amount-asc') := 'f160';
    fa_list('sort-amount-desc') := 'f161';
    fa_list('sort-numeric-asc') := 'f162';
    fa_list('sort-numeric-desc') := 'f163';
    fa_list('thumbs-up') := 'f164';
    fa_list('thumbs-down') := 'f165';
    fa_list('youtube-square') := 'f166';
    fa_list('youtube') := 'f167';
    fa_list('xing') := 'f168';
    fa_list('xing-square') := 'f169';
    fa_list('youtube-play') := 'f16a';
    fa_list('dropbox') := 'f16b';
    fa_list('stack-overflow') := 'f16c';
    fa_list('instagram') := 'f16d';
    fa_list('flickr') := 'f16e';
    fa_list('adn') := 'f170';
    fa_list('bitbucket') := 'f171';
    fa_list('bitbucket-square') := 'f172';
    fa_list('tumblr') := 'f173';
    fa_list('tumblr-square') := 'f174';
    fa_list('long-arrow-down') := 'f175';
    fa_list('long-arrow-up') := 'f176';
    fa_list('long-arrow-left') := 'f177';
    fa_list('long-arrow-right') := 'f178';
    fa_list('apple') := 'f179';
    fa_list('windows') := 'f17a';
    fa_list('android') := 'f17b';
    fa_list('linux') := 'f17c';
    fa_list('dribbble') := 'f17d';
    fa_list('skype') := 'f17e';
    fa_list('foursquare') := 'f180';
    fa_list('trello') := 'f181';
    fa_list('female') := 'f182';
    fa_list('male') := 'f183';
    fa_list('gittip') := 'f184';
    fa_list('sun-o') := 'f185';
    fa_list('moon-o') := 'f186';
    fa_list('archive') := 'f187';
    fa_list('bug') := 'f188';
    fa_list('vk') := 'f189';
    fa_list('weibo') := 'f18a';
    fa_list('renren') := 'f18b';
    fa_list('pagelines') := 'f18c';
    fa_list('stack-exchange') := 'f18d';
    fa_list('arrow-circle-o-right') := 'f18e';
    fa_list('arrow-circle-o-left') := 'f190';
    fa_list('toggle-left') := 'f191';
    fa_list('caret-square-o-left') := 'f191';
    fa_list('dot-circle-o') := 'f192';
    fa_list('wheelchair') := 'f193';
    fa_list('vimeo-square') := 'f194';
    fa_list('turkish-lira') := 'f195';
    fa_list('try') := 'f195';
    fa_list('plus-square-o') := 'f196';
    fa_list('space-shuttle') := 'f197';
    fa_list('slack') := 'f198';
    fa_list('envelope-square') := 'f199';
    fa_list('wordpress') := 'f19a';
    fa_list('openid') := 'f19b';
    fa_list('institution') := 'f19c';
    fa_list('bank') := 'f19c';
    fa_list('university') := 'f19c';
    fa_list('mortar-board') := 'f19d';
    fa_list('graduation-cap') := 'f19d';
    fa_list('yahoo') := 'f19e';
    fa_list('google') := 'f1a0';
    fa_list('reddit') := 'f1a1';
    fa_list('reddit-square') := 'f1a2';
    fa_list('stumbleupon-circle') := 'f1a3';
    fa_list('stumbleupon') := 'f1a4';
    fa_list('delicious') := 'f1a5';
    fa_list('digg') := 'f1a6';
    fa_list('pied-piper') := 'f1a7';
    fa_list('pied-piper-alt') := 'f1a8';
    fa_list('drupal') := 'f1a9';
    fa_list('joomla') := 'f1aa';
    fa_list('language') := 'f1ab';
    fa_list('fax') := 'f1ac';
    fa_list('building') := 'f1ad';
    fa_list('child') := 'f1ae';
    fa_list('paw') := 'f1b0';
    fa_list('spoon') := 'f1b1';
    fa_list('cube') := 'f1b2';
    fa_list('cubes') := 'f1b3';
    fa_list('behance') := 'f1b4';
    fa_list('behance-square') := 'f1b5';
    fa_list('steam') := 'f1b6';
    fa_list('steam-square') := 'f1b7';
    fa_list('recycle') := 'f1b8';
    fa_list('automobile') := 'f1b9';
    fa_list('car') := 'f1b9';
    fa_list('cab') := 'f1ba';
    fa_list('taxi') := 'f1ba';
    fa_list('tree') := 'f1bb';
    fa_list('spotify') := 'f1bc';
    fa_list('deviantart') := 'f1bd';
    fa_list('soundcloud') := 'f1be';
    fa_list('database') := 'f1c0';
    fa_list('file-pdf-o') := 'f1c1';
    fa_list('file-word-o') := 'f1c2';
    fa_list('file-excel-o') := 'f1c3';
    fa_list('file-powerpoint-o') := 'f1c4';
    fa_list('file-photo-o') := 'f1c5';
    fa_list('file-picture-o') := 'f1c5';
    fa_list('file-image-o') := 'f1c5';
    fa_list('file-zip-o') := 'f1c6';
    fa_list('file-archive-o') := 'f1c6';
    fa_list('file-sound-o') := 'f1c7';
    fa_list('file-audio-o') := 'f1c7';
    fa_list('file-movie-o') := 'f1c8';
    fa_list('file-video-o') := 'f1c8';
    fa_list('file-code-o') := 'f1c9';
    fa_list('vine') := 'f1ca';
    fa_list('codepen') := 'f1cb';
    fa_list('jsfiddle') := 'f1cc';
    fa_list('life-bouy') := 'f1cd';
    fa_list('life-buoy') := 'f1cd';
    fa_list('life-saver') := 'f1cd';
    fa_list('support') := 'f1cd';
    fa_list('life-ring') := 'f1cd';
    fa_list('circle-o-notch') := 'f1ce';
    fa_list('ra') := 'f1d0';
    fa_list('rebel') := 'f1d0';
    fa_list('ge') := 'f1d1';
    fa_list('empire') := 'f1d1';
    fa_list('git-square') := 'f1d2';
    fa_list('git') := 'f1d3';
    fa_list('hacker-news') := 'f1d4';
    fa_list('tencent-weibo') := 'f1d5';
    fa_list('qq') := 'f1d6';
    fa_list('wechat') := 'f1d7';
    fa_list('weixin') := 'f1d7';
    fa_list('send') := 'f1d8';
    fa_list('paper-plane') := 'f1d8';
    fa_list('send-o') := 'f1d9';
    fa_list('paper-plane-o') := 'f1d9';
    fa_list('history') := 'f1da';
    fa_list('circle-thin') := 'f1db';
    fa_list('header') := 'f1dc';
    fa_list('paragraph') := 'f1dd';
    fa_list('sliders') := 'f1de';
    fa_list('share-alt') := 'f1e0';
    fa_list('share-alt-square') := 'f1e1';
    fa_list('bomb') := 'f1e2';
    fa_list('soccer-ball-o') := 'f1e3';
    fa_list('futbol-o') := 'f1e3';
    fa_list('tty') := 'f1e4';
    fa_list('binoculars') := 'f1e5';
    fa_list('plug') := 'f1e6';
    fa_list('slideshare') := 'f1e7';
    fa_list('twitch') := 'f1e8';
    fa_list('yelp') := 'f1e9';
    fa_list('newspaper-o') := 'f1ea';
    fa_list('wifi') := 'f1eb';
    fa_list('calculator') := 'f1ec';
    fa_list('paypal') := 'f1ed';
    fa_list('google-wallet') := 'f1ee';
    fa_list('cc-visa') := 'f1f0';
    fa_list('cc-mastercard') := 'f1f1';
    fa_list('cc-discover') := 'f1f2';
    fa_list('cc-amex') := 'f1f3';
    fa_list('cc-paypal') := 'f1f4';
    fa_list('cc-stripe') := 'f1f5';
    fa_list('bell-slash') := 'f1f6';
    fa_list('bell-slash-o') := 'f1f7';
    fa_list('trash') := 'f1f8';
    fa_list('copyright') := 'f1f9';
    fa_list('at') := 'f1fa';
    fa_list('eyedropper') := 'f1fb';
    fa_list('paint-brush') := 'f1fc';
    fa_list('birthday-cake') := 'f1fd';
    fa_list('area-chart') := 'f1fe';
    fa_list('pie-chart') := 'f200';
    fa_list('line-chart') := 'f201';
    fa_list('lastfm') := 'f202';
    fa_list('lastfm-square') := 'f203';
    fa_list('toggle-off') := 'f204';
    fa_list('toggle-on') := 'f205';
    fa_list('bicycle') := 'f206';
    fa_list('bus') := 'f207';
    fa_list('ioxhost') := 'f208';
    fa_list('angellist') := 'f209';
    fa_list('cc') := 'f20a';
    fa_list('shekel') := 'f20b';
    fa_list('sheqel') := 'f20b';
    fa_list('ils') := 'f20b';
    fa_list('meanpath') := 'f20c';
  
    -- Read the data based on the region source query
    -- In the query
    -- the first column is the title(null or '...' and string
    -- the 2nd column is the percentage value(0 or greater) and number
    -- the 3rd column is the Target percentage value(0 or greater) and number
    -- the 4th column is the font awesome icon(null or icon name) and string
  
    l_col_data_type_list(g_title_col) := apex_plugin_util.c_data_type_varchar2;
    l_col_data_type_list(g_value_col) := apex_plugin_util.c_data_type_number;
    l_col_data_type_list(g_trend_col) := apex_plugin_util.c_data_type_number;
    l_col_data_type_list(g_symbol_col) := apex_plugin_util.c_data_type_varchar2;
    --
  
    l_col_val_list := apex_plugin_util.get_data2(p_sql_statement  => p_region.source,
                                                 p_min_columns    => 2,
                                                 p_max_columns    => 4,
                                                 p_data_type_list => l_col_data_type_list,
                                                 p_component_name => p_region.name);
  
    l_js_code := '';
  
    /*apex_application.show_error_message(p_message => 'this',
    p_footer  => l_col_val_list(l_col_val_list.first).value_list.count
    );*/
    For i in 1 .. l_col_val_list(l_col_val_list.first).value_list.count loop
      v_Options := '';
    
      --==Query Columns and Main Values==---
      ---------------------------------
      l_title   := sys.htf.escape_sc(l_col_val_list(g_title_col).value_list(i)
                                     .varchar2_value);
      l_percent := sys.htf.escape_sc(l_col_val_list(g_value_col).value_list(i)
                                     .number_value);
    
      if l_col_val_list.exists(g_trend_col) then
        l_target := sys.htf.escape_sc(NVL(l_col_val_list(g_trend_col).value_list(i)
                                          .number_value,
                                          0));
      end if;
    
      l_icon := 'none';
      if l_col_val_list.exists(g_symbol_col) and l_col_val_list(g_symbol_col).value_list(i)
        .varchar2_value is not null then
        l_icon := sys.htf.escape_sc(l_col_val_list(g_symbol_col).value_list(i)
                                    .varchar2_value);
      
      elsif atr_icon.exists(i) and atr_icon(i) is not null then
        l_icon := sys.htf.escape_sc(atr_icon(i));
      end if;
    
      v_Options := V_Options ||
                   apex_javascript.add_attribute('percent', l_percent);
    
      v_Options := V_Options ||
                   apex_javascript.add_attribute('targetPercent', l_target);
    
      ---getting the unicode value
      if length(l_icon) > 4 then
        icon      := substr(STR1 => l_icon, POS => 4, LEN => length(l_icon));
        icon      := fa_list(icon);
        v_Options := V_Options ||
                     apex_javascript.add_attribute('icon', icon);
      end if;
    
      --End "Query Columns and Main Values"
      -------------------------------------------------------
    
      --Template----
      -----------------------
      l_regStart := l_regTemp;
      l_html     := l_html || l_regStart;
    
      IF atr_templ = 3 then
        l_html := REPLACE(l_html, '%TITLE_TEMPL%', l_reg_Temp_Header);
        l_html := REPLACE(l_html, '%REG_TITLE%', Nvl(l_title, l_regTitle));
      else
        l_html := REPLACE(l_html, '%TITLE_TEMPL%', '');
      
        v_Options := V_Options ||
                     apex_javascript.add_attribute('text', l_title);
      
        v_Options := V_Options || apex_javascript.add_attribute('textColor',
                                                                case
                                                                  when atr_title_color.exists(i) then
                                                                   atr_title_color(i)
                                                                -- else '' -- '#666'
                                                                end);
      
        v_Options := V_Options || apex_javascript.add_attribute('textStyle',
                                                                case
                                                                  when atr_title_style.exists(i) then
                                                                   atr_title_style(i)
                                                                -- else '' -- '#666'
                                                                end);
      
        atr_title_curr_XY(1) := null;
        atr_title_curr_XY(2) := null;
      
        if atr_title_XY.exists(i) AND atr_title_XY(i) is Not null AND
           InStr(':' || p_region.attribute_25 || ':', ':1:') <= 0 then
        
          atr_title_curr_XY := APEX_UTIL.STRING_TO_TABLE(atr_title_XY(i),
                                                         ';');
        
          v_Options := V_Options || apex_javascript.add_attribute('textY',
                                                                  case
                                                                    when atr_title_curr_XY.exists(1) then
                                                                     atr_title_curr_XY(1)
                                                                  -- else '' -- '#666'
                                                                  end);
          v_Options := V_Options || apex_javascript.add_attribute('textX',
                                                                  case
                                                                    when atr_title_curr_XY.exists(2) then
                                                                     atr_title_curr_XY(2)
                                                                  -- else '' -- '#666'
                                                                  end);
        
        end if;
      
        v_Options := V_Options ||
                     apex_javascript.add_attribute('textAdditionalCss',
                                                   'ads');
      
      end if;
      l_html := REPLACE(l_html,
                        '%COL_SPAN%',
                        case
                          when atr_col_span.exists(i) AND atr_col_span(i) is NOT NULL AND
                               TO_NUMBER(atr_col_span(i)) between 1 and 12 then
                           atr_col_span(i)
                          else
                           3
                        end);
      l_html := l_html || '<span  id="circli' || i || '"></span>';
      l_html := l_html || l_regEnd;
    
      --Template End----
    
      v_Options := V_Options || apex_javascript.add_attribute('percentageTextSize',
                                                              case
                                                                when atr_perc_txt_size.exists(i) then
                                                                 atr_perc_txt_size(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      if atr_perc_XY_pos.exists(i) AND atr_perc_XY_pos(i) is Not null then
        atr_perc_curr_XY_pos(1) := null;
        atr_perc_curr_XY_pos(2) := null;
        atr_perc_curr_XY_pos := APEX_UTIL.STRING_TO_TABLE(atr_perc_XY_pos(i),
                                                          ';');
      
        v_Options := V_Options || apex_javascript.add_attribute('percentageY',
                                                                case
                                                                  when atr_perc_curr_XY_pos.exists(1) then
                                                                   atr_perc_curr_XY_pos(1)
                                                                -- else '' -- '#666'
                                                                end);
        v_Options := V_Options || apex_javascript.add_attribute('percentageX',
                                                                case
                                                                  when atr_perc_curr_XY_pos.exists(2) then
                                                                   atr_perc_curr_XY_pos(2)
                                                                -- else '' -- '#666'
                                                                end);
      
      end if;
    
      v_Options := V_Options || apex_javascript.add_attribute('fontColor',
                                                              case
                                                                when atr_perc_font_color.exists(i) then
                                                                 atr_perc_font_color(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('decimals',
                                                              case
                                                                when atr_perc_decimals.exists(i) then
                                                                 atr_perc_decimals(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('targetTextSize',
                                                              case
                                                                when atr_targ_font_size.exists(i) AND
                                                                     wwv_flow_utilities.is_numeric(atr_targ_font_size(i)) then
                                                                 atr_targ_font_size(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('targetColor',
                                                              case
                                                                when atr_targ_font_color.exists(i) then
                                                                 atr_targ_font_color(i)
                                                              -- else '' -- '#666'
                                                              end);
      ---==Icons====-----
      -----------------------------------
      v_Options := V_Options || apex_javascript.add_attribute('iconColor',
                                                              case
                                                                when atr_icon_color.exists(i) then
                                                                 atr_icon_color(i)
                                                              -- else '' -- '#666'
                                                              end);
      v_Options := V_Options || apex_javascript.add_attribute('iconSize',
                                                              case
                                                                when atr_icon_size.exists(i) AND
                                                                     wwv_flow_utilities.is_numeric(atr_icon_size(i)) then
                                                                 atr_icon_size(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('iconPosition',
                                                              case
                                                                when atr_icon_position.exists(i) then
                                                                 atr_icon_position(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      ---===Circles====---------------------------------
    
      v_Options := V_Options || apex_javascript.add_attribute('pointSize',
                                                              case
                                                                when atr_circ_perc_size.exists(i) AND
                                                                     wwv_flow_utilities.is_numeric(atr_circ_perc_size(i)) then
                                                                 atr_circ_perc_size(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('pointColor',
                                                              case
                                                                when atr_circ_perc_color.exists(i) then
                                                                 atr_circ_perc_color(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('fillColor',
                                                              case
                                                                when atr_circ_perc_outer_color.exists(i) then
                                                                 atr_circ_perc_outer_color(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('backgroundColor',
                                                              case
                                                                when atr_circ_main_color.exists(i) then
                                                                 atr_circ_main_color(i)
                                                              -- else '' -- '#666'
                                                              end);
      v_Options := V_Options || apex_javascript.add_attribute('backgroundBorderWidth',
                                                              case
                                                                when atr_circ_main_border_width.exists(i) then
                                                                 atr_circ_main_border_width(i)
                                                              -- else '' -- '#666'
                                                              end);
      v_Options := V_Options || apex_javascript.add_attribute('foregroundColor',
                                                              case
                                                                when atr_perc_circum_seg_color.exists(i) then
                                                                 atr_perc_circum_seg_color(i)
                                                              -- else '' -- '#666'
                                                              end);
      v_Options := V_Options || apex_javascript.add_attribute('foregroundBorderWidth',
                                                              case
                                                                when atr_perc_circum_seg_width.exists(i) then
                                                                 atr_perc_circum_seg_width(i)
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('animationStep',
                                                              case
                                                                when atr_animation_step.exists(i) AND
                                                                     wwv_flow_utilities.is_numeric(atr_animation_step(i)) then
                                                                
                                                                 to_number(atr_animation_step(i))
                                                              -- else '' -- '#666'
                                                              end);
    
      v_Options := V_Options || apex_javascript.add_attribute('halfCircle',
                                                              case
                                                                when atr_half_circle.exists(i) then
                                                                 f_yn_2_truefalse(atr_half_circle(i))
                                                              -- else '' -- '#666'
                                                              end);
    
      /*
      Options in the plugin have display values for options e,g toggleSelected','autoClose','keyboardNav'
      with return values as 1,2,3,4....
      Here the aar_opts is populated with the actula JS option for the corresponding Plugin Display Option value
      so their index 1,2,3 ….. are synced
      */
      aar_opts := ass_tab('textBelow',
                          'animation',
                          'animateInView',
                          'alwaysDecimals',
                          'showPercent',
                          'noPercentageSign',
                          'multiPercentage');
      --populate the selected options in the aar_sels varray, since atr_Options(i)[plugin opt attr] will return
      --the return values of the selected as ,2,5,8....
      --So the aar_opts(2) = autoClose ,  aar_opts(5) = clearButton
      /*     apex_application.show_error_message(p_message => 'assad',
      p_footer  =>p_region.attribute_25);*/
      FOR i IN 1 .. atr_Options.count LOOP
        aar_sels.extend;
      
        aar_sels(i) := aar_opts(to_NUMBER(atr_Options(i)));
      END LOOP;
      aar_unsels := aar_opts MULTISET except aar_sels;
    
      l_idx := aar_sels.first;
      while (l_idx is not null) loop
        IF aar_sels(l_idx) = 'animation' OR aar_sels(l_idx) = 'showPercent' OR
           aar_sels(l_idx) = 'multiPercentage' then
          v_Options := V_Options ||
                       apex_javascript.add_attribute(aar_sels(l_idx), 1);
        
        ELSE
          v_Options := V_Options ||
                       apex_javascript.add_attribute(aar_sels(l_idx), true);
        ENd If;
        l_idx := aar_sels.next(l_idx);
      end loop;
    
      l_idx := aar_unsels.first;
      while (l_idx is not null) loop
        IF aar_unsels(l_idx) in
           ('animation', 'showPercent', 'multiPercentage') then
          v_Options := V_Options ||
                       apex_javascript.add_attribute(aar_unsels(l_idx), 0);
        ELSE
          v_Options := V_Options ||
                       apex_javascript.add_attribute(aar_unsels(l_idx),
                                                     false);
        ENd If;
      
        l_idx := aar_unsels.next(l_idx);
      end loop;
    
      ---AJAX---
      --=============================================
    
      v_Options := V_Options ||
                   apex_javascript.add_attribute('noDataFoundMessage',
                                                 p_region.no_data_found_message);
    
      v_Options := V_Options ||
                   apex_javascript.add_attribute('pageItems',
                                                 apex_plugin_util.page_item_names_to_jquery(p_region.ajax_items_to_submit));
    
      v_Options := V_Options ||
                   apex_javascript.add_attribute('ajaxIdentifier',
                                                 apex_plugin.get_ajax_identifier);
    
      v_Options := V_Options ||
                   apex_javascript.add_attribute('description',
                                                 '',
                                                 false,
                                                 false);
    
      /*  l_js_code := l_js_code || ';apex.jQuery(''' || '#circli' || i ||
      ''').circlifulGuage(' ||
      apex_javascript.add_value(p_region.static_id) || ',{' ||
      v_Options || '});';*/
      l_js_code := l_js_code || 'circlifulGuage("circli' || i || '",{' ||
                   v_Options || '});';
    End loop;
  
    /*
    l_lov := apex_plugin_util.get_data(p_sql_statement  => atr_sql_qry,
                                       p_min_columns    => 1,
                                       p_max_columns    => 3,
                                       p_component_name => p_region.);
    for i in 1 .. l_lov(g_icon_col).count loop
      l_icon  := l_lov(g_icon_col) (i);
      l_value := l_lov(g_value_col) (i);
      if l_lov.exists(g_title_col) then
        l_title := l_lov(g_title_col) (i);
      end if;
    
      l_html  := l_html || '<a  title="' || l_title || '" href=' || l_value ||
                 ' ><i class="t-Icon fa ' || l_icon ||
                 '" aria-hidden="true"></i></a>';
    end loop;*/
  
    /*    l_html := l_html || l_regStart;
    l_html := l_html || '<span  id="test-circle"></span>';
    l_html := l_html || l_regEnd;
    l_html := l_html || l_regStart;
    l_html := l_html || '<span  id="test-circle2"></span>';
    l_html := l_html || l_regEnd;
    l_html := l_html || l_regStart;
    l_html := l_html || '<span  id="test-circle3"></span>';
    l_html := l_html || l_regEnd;
    l_html := l_html || l_regStart;
    l_html := l_html || '<span  id="test-circle4"></span>';
    l_html := l_html || l_regEnd;
    l_html := l_html || l_regStart;
    l_html := l_html || '<span  id="test-circle5"></span>';
    l_html := l_html || l_regEnd;*/
  
    sys.htp.p(l_html);
  
    apex_javascript.add_onload_code(p_code => l_js_code);
  
    -- return l_render_result;
    return null;
  end f_render_guage;

end pkg_kpi;
/
