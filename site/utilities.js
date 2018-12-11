function reconcile_balances(tag)
{
   function send_for_update()
   {
      var url = "Person.srm?reconcile";
      
   }

   function find_result(_tag)
   {
      var xpath = "/*/*[@rndx][@tag='" + _tag + "']";
      return SFW.xmldoc.selectSingleNode(xpath);
   }

   function find_target(_tag)
   {
      var arr = document.getElementsByTagName("table");
      for (var i=0,stop=arr.length; i<stop; ++i)
      {
         if (arr[i].getAttribute("data-tag")==_tag)
            return arr[i];
      }
      return null;
   }

   function show_message(doc)
   {
      var result, msg, xpath="/*/*[@rndx][@type='outcome']/*[local-name()=../@row-name]";
      if ((result = doc.selectSingleNode(xpath)) && (msg=result.getAttribute("msg")))
          SFW.alert(msg);
   }

   function _reconcile_balances(tag)
   {
      var target = find_target(tag)
      if (target)
      {
         target.style.backgroundColor="purple";

         var result = find_result(tag);
         if (result)
         {
            function plot(doc)
            {
               show_message(doc);
               var replace = doc.selectSingleNode("/*/*[@rndx][@type='replace']");
               if (replace)
               {
                  var source = SFW.get_result_to_replace(replace);
                  SFW.xslobj.transformFill(target, source);
               }
            }
            SFW.run_task("Person.srm?reconcile", plot);
         }
         else
            SFW.alert("find target, but not the source.");
      }
      else
         SFW.alert("failed to find the target.");
   }

   reconcile_balances = _reconcile_balances;
   _reconcile_balances(tag);
}

function person_reconcile_balances()
{
   reconcile_balances("Person_List");
}
