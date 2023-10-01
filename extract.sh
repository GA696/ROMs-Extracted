read -p "Enter Build Name: " filename
unzip $filename -d vose

echo "Decompressing system.new.dat.br"
brotli --decompress vose/system.new.dat.br -o vose/system.new.dat
if [ $? != 0 ]
then
echo "Stoped at decompressing system.new.dat.br"
exit 1
fi

echo "Extracting system.new.dat"
python3 sdat2img.py vose/system.transfer.list vose/system.new.dat vose/system.img
if [ $? != 0 ]
then
echo "Stoped at Extracting system.new.dat"
exit 1
fi

echo "Removing system.new.dat"
rm vose/system.new.dat
if [ $? != 0 ]
then
echo "Stoping at Removing system.new.dat"
exit 1
fi

echo "Decompressing vendor.new.dat.br"
brotli --decompress vose/vendor.new.dat.br -o vose/vendor.new.dat
if [ $? != 0 ]
then
echo "Stoped at decompressing vendor.new.dat.br"
exit 1
fi

echo "Extracting vendor.new.dat"
python3 sdat2img.py vose/vendor.transfer.list vose/vendor.new.dat vose/vendor.img
if [ $? != 0 ]
then
echo "Stoped at Extracting vendor.new.dat"
exit 1
fi

echo "Removing vendor.new.dat"
rm vose/vendor.new.dat
if [ $? != 0 ]
then
echo "Stoping at Removing vendor.new.dat"
exit 1
fi

echo "Creating Folder system, vendor"
mkdir "system"
mkdir "vendor"

echo "Mounting img"
sudo mount -rw vose/system.img system
sudo mount -rw vose/vendor.img vendor


sudo chown -R $UID system vendor

echo "git add"
git add .

echo "git commit"
git commit -m $filename

echo "unmount"
sudo umount "system"
sudo umount "vendor"

rm -r system vendor vose