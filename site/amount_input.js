(function _init()
 {
    var file_name="amount_input", base_class_name="iclass", class_name="amount_input";
    var constructor = _amount_input;
    
    if ((!("SFW" in window) && setTimeout(_init,100))
        || SFW.delay_init(file_name, _init, base_class_name))
       return;

    if (!SFW.derive(constructor, class_name, base_class_name))
       return;

    function _amount_input(actors)
    {
       SFW.base.call(this,actors);
    }

    // Restrict input to numerals and zero or one periods, only.
    // Negative values not allowed, must declare as debit or credit.
    _amount_input.prototype.process = function(e,t)
    {
       if (e.type=="keypress")
       {
          var kchar = SFW.keychar_from_event(e);

          if ("0123456789".indexOf(kchar)!=-1)
             return true;

          if (kchar=='.')
          {
             if (t.value.indexOf('.')!=-1)
                return SFW.cancel_event(e);
          }
          else
             return SFW.cancel_event(e);
       }
       return true;
    };

 }
)();



