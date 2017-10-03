mkdir -p ~/neologd-tmp
cd ~/neologd-tmp
if [ ! -d ./mecab-ipadic-neologd ];then
  git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
fi
cd mecab-ipadic-neologd
./bin/install-mecab-ipadic-neologd -n -y
