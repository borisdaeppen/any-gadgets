mkdir data
cd data
mkdir fotos
mkdir docs
echo "Hallo Welt" > hallo.txt
echo "12345" > zahlen.txt
cd fotos
echo "A" > a.jpg
echo "B" > b.jpg
cd ../docs
echo "Foo Bar" > zeugs.txt

sleep 1

cd ../..
cp -a data full_1

sleep 1

echo "X" >> data/hallo.txt
echo "Y" >> data/fotos/b.jpg
echo "Z" >> data/docs/zeugs.txt

touch data/neu.txt
