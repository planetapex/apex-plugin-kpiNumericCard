/**
 * kpiNumericcard.js
 *
 * @fileoverview  Apex plugin that displays KPI information in the form of Numeric Cards.
 * @link          https://github.com/planetapex/apex-plugin-kpiNumericCard/
 * @author        M.Yasir Ali Shah (https://apexfusion.blogspot.com/)
 * @version       1.0
 * @requires      jQuery 1.8+
 *
 * @license kpiNumericCards  Apex Plugin v1.0
 * https://github.com/planetapex/apex-plugin-kpiNumericCard/
 * Copyright 2017 - M.Yasir Ali Shah (https://apexfusion.blogspot.com/p/about)
 * Released under the MIT license.
 * <https://raw.github.com/planetapex/apex-plugin-kpiNumericCard/master/LICENSE.txt>
 */

(function (util, server, $, undefined) {
    $.widget("ui.kpiNumCards", {
        options: {
            cards: [{
                colSpan: 3
            }],
            ajaxIdentifier: null,
            pageItems: '',
            templateNo: 2,
            noDataFoundMessage: '',
            noData: false
        },
        gNoData$: null,
        gRegion$: null,
        gRegionBody$: null,


  

        _create: function () {
            var uiw = this;

            uiw.gRegion$ = $('#' + uiw.element.attr('id'), apex.gPageContext$);
            this._buildTemplate();

            uiw.gRegion$
                .on("apexrefresh", uiw._refresh.bind(uiw))
                .trigger("apexrefresh");



        }, // _create   

        _init: function () {
            var uiw = this;


        }, // _init

        _buildTemplate: function () {

            var uiw = this;
            // Find our region and chart DIV containers
            uiw.gRegion$ = $('#' + uiw.element.attr('id'), apex.gPageContext$);
            uiw.gRegionBody$ = uiw.gRegion$.find(".t-Region-body");

            // if there is no region body container, add one on the fly.
            if (uiw.gRegionBody$.length === 0) {
                var outHTML = util.htmlBuilder();
                outHTML.markup('<div class="t-Region-bodyWrap"><div class="t-Region-body kpiNumContainer"></div></div>');
                uiw.gRegionBody$ = uiw.gRegion$.append(outHTML.toString()).find(".t-Region-body");
            } else {
                uiw.gRegionBody$.addClass('kpiNumContainer');
            }




            // No Data Found container

            // Create "No Data" container
            var noDataTemplate = util.htmlBuilder();
            noDataTemplate.markup('<div class="a-kpinum-message a-kpinum-noDataFound-container">')
                .markup('<div class="a-kpinum-messageIcon  a-kpinum-noDataFound">')
                .markup('<span class="a-Icon icon-irr-help"></span></div>')
                .markup('<span class="a-kpinum-messageText">#MSG#</span></div>');

            uiw.gNoData$ = $(noDataTemplate.toString().replace('#MSG#', uiw.options.noDataFoundMessage)).hide();
            uiw.gRegionBody$.after(uiw.gNoData$);



        },


        _draw: function (data) {

            var uiw = this,
                card = this.options.cards;
                
            $.extend(this.options, data);
            var cardsCount =  this.options.cards.length,
            gOptions = uiw.options;

           

            for (var i = 0 ; i < cardsCount; i++) {
                var currCard = gOptions.cards[i],
                    cardRegtHTML = util.htmlBuilder(),
                    chart = uiw.element.attr('id') + '_' + 'kpinum_' + (i + 1),
                    template = util.htmlBuilder(),
                    finTempl;


                template.markup('<div class="col col-#COL_SPAN#">');
                if (gOptions.templateNo == 2) {
                    template.markup('<div class="t-Region t-Region--scrollBody t-Region-bodyWrap" role="group" aria-labelledby="' + uiw.element.attr('id') + '_card_heading"><div class="t-Region-body">');

                } else if (gOptions.templateNo == 3) {
                    template.markup('<div class="t-Region t-Region--scrollBody" role="group" aria-labelledby="' + uiw.element.attr('id') + '_card_heading">')
                        .markup('<div class="t-Region-header"><div class="t-Region-headerItems t-Region-headerItems--title"><h2 class="t-Region-title" id="' + uiw.element.attr('id') + '_card_heading">#REG_TITLE#</h2></div>')
                        .markup('</div><div class="t-Region-bodyWrap"><div class="t-Region-body">');
                }



                // template.markup('<span id = "' + chart + '"></span>');
                template.markup('<div id = "' + chart + '"></div>');

                if (gOptions.templateNo == 1) {
                    template.markup('</div>');
                } else if (gOptions.templateNo == 2) {
                    template.markup('</div></div>');

                } else {
                    template.markup('</div></div></div></div>');
                }

                finTempl = template.toString().replace('#COL_SPAN#', currCard.colSpan);

                if (gOptions.templateNo == 3) {
                    finTempl = finTempl.replace('#REG_TITLE#', currCard.title);

                } else {
                    finTempl = finTempl.replace('#REG_TITLE#', '');
                }



                if (gOptions.templateNo == 3) {
                    currCard.title = '';


                }

                // finTempl = util.applyTemplate(cardRegtHTML.toString(), templOpts);

                // gRegionBody$.append(cardRegtHTML.toString());
                // var cardReg$ = $(cardRegtHTML.toString());
                uiw.gRegionBody$.append(finTempl);
                // Time to draw the chart!
                // apex.jQuery('#' + util.escapeCSS(pRegionId)).kpinumful(gChartOptions);



                // $('#' + chart).kpinumful(currCard);

                var kpiWidget = $('#' + chart).NumTrendKPI(currCard);

                // //  if ( url || url !== "" ) $('#' + chart).NumTrendKPI('clickHandler',currCard.currCard);
                // console.log('chr',$('#' + chart+ ' div.num-trend-kpi-container div.kpi-data'));
                
                // if ( currCard.url  || currCard.url !== "" ) {
                // $('#' + chart + ' div.num-trend-kpi-container div.kpi-data')
                // .on('click', function () {
                //     console.log('click', i + ' ' + currCard.url);
                //     eval(currCard.url);
                //     //   url = "javascript:void(0)";
                // })
                // .on('mouseenter', function () {
                //     $(this).css('cursor','pointer');
                // })
                   
                // }       


                if (gOptions.templateNo == 1) {

                    $('#' + chart + ' .kpi-title').css('background-color', currCard.headerColor);
                    $('#' + chart + ' .kpi-title').css({
                        'color': currCard.headerFontColor,
                        'font-size': currCard.headerFontSize + 'px'
                    });

                    $('#' + chart + ' .num-trend-kpi-container').css('background-color', currCard.cardColor);

                    $('#' + chart + ' .num-trend-kpi-container .kpi-data.num-trend-kpi-data .num-trend-kpi-data-text').css({
                        'color': currCard.cardTextColor,
                        'font-size': currCard.cardTextSize + 'px'
                    });

                    $('#' + chart + ' .num-trend-kpi-container .num-trend-kpi-footer .kpi-footer-text').css({
                        'color': currCard.FooterTextColor,
                        'font-size': currCard.FooterTextSize + 'px'
                    });



                } else if (gOptions.templateNo == 2 || gOptions.templateNo == 3 ) {

                    $('#' + chart + ' .kpi-title').hide();
                    $('#' + chart).closest('.t-Region-body').css("padding", "0px");
                    $('#' + chart + ' .num-trend-kpi-container').css("box-shadow", "none");

                    $('#' + chart).closest('.t-Region-bodyWrap').prev().css('background-color', currCard.headerColor);
                    $('#' + chart).closest('.t-Region-bodyWrap').prev().find('.t-Region-title').css({
                        'color': currCard.headerFontColor,
                        'font-size': currCard.headerFontSize + 'px'
                    });
                    // console.log('s', $('#' + chart + ' .num-trend-kpi-container .kpi-data.num-trend-kpi-data .num-trend-kpi-data-text'));
                    $('#' + chart + ' .num-trend-kpi-container').css('background-color', currCard.cardColor);

                    $('#' + chart + ' .num-trend-kpi-container .kpi-data.num-trend-kpi-data .num-trend-kpi-data-text').css({
                        'color': currCard.cardTextColor,
                        'font-size': currCard.cardTextSize + 'px'
                    });

                    $('#' + chart + ' .num-trend-kpi-container .num-trend-kpi-footer .kpi-footer-text').css({
                        'color': currCard.FooterTextColor,
                        'font-size': currCard.FooterTextSize + 'px'
                    });




                }


            } //for loop

            if (gOptions.templateNo == 3) {

                // $('#' + uiw.element.attr('id')).find('.kpi-title').each(function(i, k) {

                //     $(k).hide();

                // });
                // $('#' + uiw.element.attr('id')).find('.num-trend-kpi-container').each(function(i, k) {

                //     $(k).css("box-shadow", "none");

                // });

                // $('#' + uiw.element.attr('id')).find('.kpiNumContainer .t-Region-bodyWrap .t-Region-body').each(function(i, k) {

                //     $(k).css("padding", "0px");

                // });

                // $('#' + uiw.element.attr('id')).find('.kpiNumContainer .t-Region-bodyWrap .t-Region-body').each(function(i, k) {

                //     $(k).css("padding", "0px");

                // });



            }

        }, // _draw

        _debug: function (i) {


            apex.debug.log(i);
        },

        // Removes everything inside the chart DIV
        _clear: function () {


        }, // _clear


        // Called by the APEX refresh event to get new chart data
        _refresh: function () {


            var uiw = this,

                // gRegion$ = $('#' + uiw.element.attr('id'), apex.gPageContext$),
                // gRegionBody$ = gRegion$.find(".t-Region-body"),
                lSpinner$;

            apex.server.plugin(
                uiw.options.ajaxIdentifier, {
                    pageItems: uiw.options.pageItems
                }, {
                    dataType: "json",
                    accept: "application/json",
                    beforeSend: function () {


                        lSpinner$ = apex.util.showSpinner(uiw.gRegion$);
                    },
                    success: function (gReturn) {


                        if (gReturn.cards.length >= 1) {
                            uiw.gNoData$.hide();
                            uiw.gRegionBody$.show();
                            uiw.gRegionBody$.html('');
                            uiw._draw(gReturn);
                        } else {
                            uiw.gRegionBody$.hide();
                            uiw.gNoData$.show();
                        }

                    },

                    complete: function (data) {

                        lSpinner$.remove();
                    },
                    error: uiw._debug,
                    clear: uiw._clear

                }
            );


        }, // _refresh

        _createTag: function (tag) {
            return $(document.createElement(tag));
        }

    }); // ui.kpiNumCard

})(apex.util, apex.server, apex.jQuery);