(function _init()
 {
    var file_name="sublines", base_class_name="iclass", class_name="sublines";
    
    if ((!("SFW" in window) && setTimeout(_init,100))
        || SFW.delay_init(file_name, _init, base_class_name))
       return;

    var ctor = _sublines;

    if (!SFW.derive(ctor, class_name, base_class_name))
       return;

    function _sublines(actors)
    {
       SFW.base.call(this,actors);
    }

    _sublines.prototype.get_schema_field = function()
    {
       var fname = this.get_field_name();
       if (fname)
       {
          var xpath = "/*/schema[field/@name='" + fname + "'][1]/field[@name='" + fname + "']";
          return this.xmldoc().selectSingleNode(xpath);
       }
       return null;
    };

    _sublines.prototype.get_target_result = function()
    {
       var field, result;
       if ((field=this.get_schema_field()))
       {
          var xpath = "/*/*[@rndx][local-name()='" + field.getAttribute("result") + "']";
          return this.xmldoc().selectSingleNode(xpath);
       }
       return null;
    };

    /**
     * The element just before the widget is the element for the HTTP-submitted form.
     * The first child input element of the widget is the shadow input that is updated
     * when the transaction line is submitted.  This function copies the shadow input
     * value to the HTTP-submitted form input element.
     */
    _sublines.prototype.update_input_from_shadow = function()
    {
       var form = this.widget();
       var fname = form.getAttribute("name");

       function get_target()
       {
          var t = form.previousSibling;
          while (t && t.nodeType!=1)
             t = t.previousSibling;
          return t.name==fname ? t : null;
       }

       function get_source()
       {
          var s = form.firstChild;
          while (s && s.nodeType!=1)
             s = s.nextSibling;
          return s.name == "shadow_"+fname ? s : null;
       }

       var target, source;
       if ((target=get_target()) && (source=get_source()))
          target.value = source.value;
    };

    _sublines.prototype.replot = function()
    {
       var target = this.widget();
       var field = this.get_schema_field();

       var xpath = "/*/*[@rndx][local-name()='" + field.getAttribute("result") + "']";
       var result = field.selectSingleNode(xpath);

       if (field)
       {
          field.setAttribute("action", "replotting");
          SFW.xslobj.transformReplace(target, field);
          field.removeAttribute("action");

          this.update_input_from_shadow();
       }
    };

    _sublines.prototype.add_line_value = function()
    {
       var doc, el, result, rowname, widget;
       if ((widget=this.widget())
           && (result = this.get_target_result())
           && (doc = this.xmldoc())
           && (rowname = result.getAttribute("row-name"))
           && (el = doc.createElement(rowname)))
           {
              SFW.get_form_data_xml(widget,el);
              el.removeAttribute("shadow_tlines");
              result.appendChild(el);
              return true;
           }

       return false;
    }

    _sublines.prototype.add_line = function()
    {
       var doc, el;
       if ((doc=this.xmldoc()) && (el=doc.createElement("row")))
          if (this.add_line_value(el))
       {
          this.replot();
       }
    };

    _sublines.prototype.remove_line = function(button)
    {
       var pos = button.getAttribute("value");
       var el, result, widget, xpath;
       if ((widget=this.widget())
           && (result = this.get_target_result())
           && (xpath =result.getAttribute("row-name") + "[position()=" + pos + "]")
           && (el = result.selectSingleNode(xpath)))
       {
          result.removeChild(el);
          this.replot();
       }
    };

    _sublines.prototype.process = function(e,t)
    {
       // Allow base class to process generic buttons:
       if (!SFW.base.prototype.process.call(this,e,t))
          return false;

       var tagname = t.tagName.toLowerCase();
       var nameval = t.getAttribute("name");

       if (e.type=="click")
       {
          if (tagname=="button")
          {
             if (nameval=="add")
                 this.add_line();
             else if (nameval=="delete")
                this.remove_line(t);
          }
       }

       return true;
    };
 }
)();
