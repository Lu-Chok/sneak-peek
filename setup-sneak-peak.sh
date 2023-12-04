# APP_PATH=/Applications/Telegram.app
read -p "Drag and drop your app here to copy path: " APP_PATH

# Remove single and double quotes from path
APP_PATH=$(echo $APP_PATH | tr -d "'")

ICON_NAME=$(grep -A1 '<key>CFBundleIconFile</key>' $APP_PATH/Contents/Info.plist | grep '<string>' | awk -F'</*string>' '{print $2}' | tr -d '[:space:]' | sed 's/ *$//')
ICON_PATH=$APP_PATH/Contents/Resources/$ICON_NAME.icns

# echo $ICON_PATH

# We allow this app to be open for 60 seconds
read -p "What will be peek duration for app? (in seconds): " TIMEOUT

# Get basename of the app we open
APP_NAME=$(basename -- "$APP_PATH")
EXTENSION="${APP_NAME##*.}"
FILENAME="${APP_NAME%.*}"
FINAL_NAME=Peek-$FILENAME

# Get to application directory
OUT_DIRECTORY=/Applications
cd $OUT_DIRECTORY

# Defilne app structure
PEEK_APP_ROOT=./Peek-$APP_NAME/Contents
PEEK_APP_DIR=$PEEK_APP_ROOT/MacOS
PEEK_RESOURCES_DIR=$PEEK_APP_ROOT/Resources

# Create app structure
mkdir -p $PEEK_APP_DIR $PEEK_RESOURCES_DIR

# Copy original icon to peek app
cp $ICON_PATH $PEEK_RESOURCES_DIR/$APPNAME.icns

# Create shell file for app
cat <<EOF > $PEEK_APP_DIR/$FINAL_NAME
#!/bin/bash
open $APP_PATH;
sleep $TIMEOUT;
killall $FILENAME;
EOF

# Provide app with execution rights
chmod ugo+x $PEEK_APP_DIR/$FINAL_NAME

# Create pkginfo file
echo "APPL????" > $PEEK_APP_ROOT/PkgInfo

# Create Info.plist file
cat <<EOF > "$PEEK_APP_ROOT/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>CFBundleExecutable</key>
    <string>$APPNAME</string>
    <key>CFBundleGetInfoString</key>
    <string>$APPNAME</string>
    <key>CFBundleIconFile</key>
    <string>$APPNAME</string>
    <key>CFBundleName</key>
    <string>$APPNAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>4242</string>
  </dict>
</plist>
EOF

# Show user where to find the app
echo "Your app is ready at: $OUT_DIRECTORY/$FINAL_NAME.app"