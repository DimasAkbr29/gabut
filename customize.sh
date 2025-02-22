
ui_print "- Android Version : $(getprop ro.build.version.release)"
ui_print "- Kernel Version  : $(uname -r)"

pm install $MODPATH/toast.apk >/dev/null
rm -rf $MODPATH/toast.apk

ui_print "- Installed Games: "
counter=1
package_list=$(cmd package list packages | cut -f 2 -d ":")  
while IFS= read -r gamelist || [[ -n "$gamelist" ]]; do
line=$(echo "$gamelist" | awk '!/ /')
    if echo "$package_list" | grep -q "$line"; then
        ui_print "  $counter. $line"
        counter=$((counter + 1))
    else
        sed -i "/$line/d" "$MODPATH/game.txt"
    fi
done < "$MODPATH/game.txt"
ui_print "- If your game not dettected"
ui_print "- List your game in Game-List inside module zip and try reflash modoule"

set_perm_recursive $MODPATH 0 0 0755 0755
set_perm_recursive $MODPATH/system/bin 0 0 0777 0777