#
# = hobix/comments.rb
#
# Hobix command-line weblog system, API for comments.
#
# Copyright (c) 2003-2004 why the lucky stiff
#
# Written & maintained by why the lucky stiff <why@ruby-lang.org>
#
# This program is free software, released under a BSD license.
# See COPYING for details.
#
#--
# $Id$
#++

require 'hobix/facets/comments'

module Hobix
module Out
class Quick
append_def :head_tags_erb, %{
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="-1" />
  <script type="text/javascript" src="<%= weblog.expand_path( '/js/prototype.js' ) %>"></script>
  <script type="text/javascript">
      function quickRedReference() {
          window.open(
              "http://hobix.com/textile/quick.html",
              "redRef",
              "height=600,width=550,channelmode=0,dependent=0," +
              "directories=0,fullscreen=0,location=0,menubar=0," +
              "resizable=0,scrollbars=1,status=1,toolbar=0"
          );
      }
  </script>
}

append_def :entry_erb, %{
    <% if entry and not defined? entries %><+ entry_comment +><% end %> 
}

def entry_comment_erb; %{
  <% entry_id = entry.id %>
  <div id="comments">
  <% comments = weblog.storage.load_attached( entry_id, "comments" ) rescue [] %>
  <% comments.each do |entry| %>
  <div class="entry">
      <div class="entryAttrib">
          <div class="entryAuthor"><h3><%= entry.author %></h3></div>
          <div class="entryTime">said on <%= entry.created.strftime( "<nobr>%d %b %Y</nobr> at <nobr>%I:%M %p</nobr>" ) %></div>
      </div>
      <div class="entryContentOuter"><div class="entryContent"><%= entry.content.to_html %></div></div>
  </div>
  <% end %>
  <div class="entry">
  <form id="userComment" method="post" action="/control/comment/<%= entry_id %>">
    <div class="entryAttrib">
       <div class="entryAuthor"><input name="<%= Hobix::Facets::Comments.form_field 'author' %>" type="textbox" size="15" maxlength="50" /></div>
       <div id="liveTime" class="entryTime">said on <nobr>DD Mon YYYY</nobr> <nobr>at HH:MM AM</nobr></div>
    </div>
    <div class="entryContentOuter"><div class="entryContent">
       <textarea name="<%= Hobix::Facets::Comments.form_field 'content' %>" rows="6" cols="50"></textarea>
       <p><input type="button" name="pleasePreview" value="preview" 
           onClick="new Ajax.Request('/control/preview', {parameters: Form.serialize('userComment'), onComplete: function(req) { $('textilePreview').innerHTML = req.responseText }})" />
          <input type="submit" name="<%= Hobix::Facets::Comments.form_field 'submit' %>" value="&gt;&gt;" />
          <small>* do <a href="javascript:quickRedReference();">fancy stuff</a> in your comment.</small>
       </p>
       <div id="textileWrap"><!-- <h4>PREVIEW PANE</h4> -->
       <div id="textilePreview"></div>
       </div>
       </div>
    </div></div>
     
  </form>
  </div>
} end
end
end
end
