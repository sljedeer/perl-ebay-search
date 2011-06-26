WWW::Search::Ebay(3)                                User Contributed Perl Documentation                                WWW::Search::Ebay(3)

NAME
       WWW::Search::Ebay - backend for searching www.ebay.com

SYNOPSIS
         use WWW::Search;
         my $oSearch = new WWW::Search('Ebay');
         my $sQuery = WWW::Search::escape_query("C-10 carded Yakface");
         $oSearch->native_query($sQuery);
         while (my $oResult = $oSearch->next_result())
           { print $oResult->url, "\n"; }

DESCRIPTION
       This class is a Ebay specialization of WWW::Search.  It handles making and interpreting Ebay searches http://www.ebay.com.

       This class exports no public interface; all interaction should be done through WWW::Search objects.

NOTES
       The search is done against CURRENT running AUCTIONS only.  (NOT completed auctions, NOT eBay Stores items, NOT Buy-It-Now only
       items.)  (If you want to search completed auctions, use the WWW::Search::Ebay::Completed module.)  (If you want to search eBay
       Stores, use the WWW::Search::Ebay::Stores module.)

       The query is applied to TITLES only.

       This module can return only the first 200 results matching your query.

       In the resulting WWW::Search::Result objects, the description() field consists of a human-readable combination (joined with
       semicolon-space) of the Item Number; number of bids; and high bid amount (or starting bid amount).

       In the resulting WWW::Search::Result objects, the end_date() field contains a human-readable DTG of when the auction is scheduled to
       end (in the form "YYYY-MM-DD HH:MM TZ").  If environment variable TZ is set, the time will be converted to that timezone; otherwise
       the time will be left in ebay.com's default timezone (US/Pacific).

       In the resulting WWW::Search::Result objects, the bid_count() field contains the number of bids as an integer.

       In the resulting WWW::Search::Result objects, the bid_amount() field is a string containing the high bid or starting bid as a human-
       readable monetary value in seller-native units, e.g. "$14.95" or "GBP 6.00".

       In the resulting WWW::Search::Result objects, the category() field contains the Ebay category number.

       In the resulting WWW::Search::Result objects, the sold() field will be non-zero if the item has already sold.  (Only if you're using
       WWW::Search::Ebay::Completed)

       After a successful search, your search object will contain an element named 'categories' which will be a reference to an array of
       hashes containing names and IDs of categories and nested subcategories, and the count of items matching your query in each category
       and subcategory.  (Special thanks to Nick Lokkju for this code!)  For example:

         $oSearch->{category} = [
                 {
                   'ID' => '1',
                   'Count' => 19,
                   'Name' => 'Collectibles',
                   'Subcategory' => [
                                      {
                                        'ID' => '13877',
                                        'Count' => 11,
                                        'Name' => 'Historical Memorabilia'
                                      },
                                      {
                                        'ID' => '11450',
                                        'Count' => 1,
                                        'Name' => 'Clothing, Shoes & Accessories'
                                      },
                                    ]
                 },
                 {
                   'ID' => '281',
                   'Count' => 1,
                   'Name' => 'Jewelry & Watches',
                 }
               ];

       If your query string happens to be an eBay item number, (i.e. if ebay.com redirects the query to an auction page), you will get back
       one WWW::Search::Result without bid or price information.

OPTIONS
       Search descriptions
           To search titles and descriptions, add 'srchdesc'=>'y' to the query options:

             $oSearch->native_query($sQuery, { srchdesc => 'y' } );

       Search one category
           To restrict your search to a particular eBay category, find out eBay's ID number for the category and add 'sacategory'=>123 to
           the query options:

             $oSearch->native_query($sQuery, { sacategory => 48995 } );

           If you send a single asterisk or a single space as the query string, the results will be ALL the auctions in that category.

       Limit search by price range
           Contributed by Brian Wilson:

             $oSearch->native_query($sQuery, {
               _mPrRngCbx=>'1', _udlo=>$minPrice, _udhi=>$maxPrice,
               } );

PUBLIC METHODS OF NOTE
       user_agent_delay
           Introduce a few-seconds delay to avoid overwhelming the server.

       need_to_delay
           Controls whether we do the delay or not.

       preprocess_results_page
           Grabs the eBay Official Time so that when we parse the DTG from the HTML, we can convert / return exactly what eBay means for
           each one.

       result_as_HTML
           Given a WWW::SearchResult object representing an auction, formats it human-readably with HTML.

           An optional second argument is the date format, a string as specified for Date::Manip::UnixDate.  Default is '%Y-%m-%d %H:%M:%S'

             my $sHTML = $oSearch->result_as_HTML($oSearchResult, '%H:%M %b %E');

METHODS TO BE OVERRIDDEN IN SUBCLASSING
       You only need to read about these if you are subclassing this module (i.e. making a backend for another flavor of eBay search).

       _get_result_count_elements
           Given an HTML::TreeBuilder object, return a list of HTML::Element objects therein which could possibly contain the approximate
           result count verbiage.

       _get_itemtitle_tds
           Given an HTML::TreeBuilder object, return a list of HTML::Element objects therein representing <TD> elements which could
           possibly contain the HTML for result title and hotlink.

       _parse_category_list
           Parses the Category list from the left side of the results page.  So far, this method can handle every type of eBay search
           currently implemented.  If you find that it doesn't suit your needs, please contact the author because it's probably just a tiny
           tweak that's needed.

       _process_date_abbrevs
           Given a date string, converts common abbreviations to their full words (so that the string can be unambiguously parsed by
           Date::Manip).  For example, in the default English, 'd' becomes 'days'.

       _next_text
           The text of the "Next" button, localized for a specific type of eBay backend.

       whitespace_pattern
           Return a qr// pattern to match whitespace your webpage's language.

       _currency_pattern
           Return a qr// pattern to match mentions of money in your webpage's language.  Include the digits in the pattern.

       _title_pattern
           Return a qr// pattern to match the webpage title in your webpage's language.  Add grouping parenthesis so that $1 becomes the
           auction title, $2 becomes the eBay item number, and $3 becomes the end date.

       _result_count_pattern
           Return a qr// pattern to match the result count in your webpage's language.  Include parentheses so that $1 becomes the number
           (with commas is OK).

       _columns
           Specify the order in which data columns appear in the search results table.

SEE ALSO
       To make new back-ends, see WWW::Search.

BUGS
       Please tell the author if you find any!

AUTHOR
       Martin 'Kingpin' Thurn, "mthurn at cpan.org", <http://tinyurl.com/nn67z>.

       Some fixes along the way contributed by Troy Davis.

LEGALESE
       THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

LICENSE
       Copyright (C) 1998-2009 Martin 'Kingpin' Thurn

       This software is released under the same license as Perl itself.

perl v5.12.3                                                     2010-08-17                                            WWW::Search::Ebay(3)
