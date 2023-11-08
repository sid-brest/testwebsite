# Linux and Bash Introduction event by Dzmitry Struneuski

## Answers to the assignment questions

Linux foundations course - <https://killercoda.com/pawelpiwosz/course/linuxFundamentals>

### Terminal commands

1. Create directories structure

```bash
mkdir test; mkdir test/onefile test/manyfiles
```
2. Create files

```bash
echo "Hello! This is my string!" > test/onefile/myfile.txt
```
3. Create files

```bash
for i in {1..10000}; do touch test/manyfiles/myfile$(printf "%02d" $i); done
```
4. Use pipe

```bash
echo "New content" | tee test/onefile/copied > /dev/null && cat test/onefile/myfile.txt >> test/onefile/copied
```
5. Copy

```bash
cp test/onefile/myfile.txt test/ && cp test/onefile/myfile.txt /tmp/copiedfile
```
6. Move

```bash
mv test/onefile/myfile.txt /root && mv -n test/manyfiles test/moved
```
7. Alias

```bash
echo "alias mydir='echo \$HOME'" >> ~/.bash_aliases && source ~/.bashrc
```
8. Users

```bash
sudo bash -c 'for user in administrator appuser anotheruser; do useradd -m -s /bin/bash $user; done' && sudo usermod -aG appuser administrator
```
9. Users

```bash
sudo bash -c 'for user in administrator appuser anotheruser; do useradd -m -s /bin/bash $user; done' && sudo usermod -aG appuser administrator
```
10. Users

```bash
sudo usermod -aG sudo appuser && echo 'administrator ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/administrator
```
11. Logs

```bash
cp /var/log/auth.log /var/log/dmesg /var/log/dpkg.log ~
```
12. Crontab

```bash
crontab -e
* * * * * echo "The date is: $(date), logged by $(whoami)" 1>> /var/log/mycronlog 2>> /var/log/mycronerror
* * * * * wrongcommandhere "The date is: $(date), logged by $(whoami)" 1>> /var/log/mycronlog 2>> /var/log/mycronerror
16 17 * * 6 echo "The date is: $(date), logged by $(whoami)" 1>> /var/log/mycronlog 2>> /var/log/mycronerror
```
An additional command with which you can check the number of lines in the log files. Remember that files that contain more than one record will be validated
```bash
sudo wc -l /var/log/mycronlog /var/log/mycronerror
```
13. Symbolic link

```bash
ln -s $HOME/test/myfile.txt $HOME/linkedfile
```
14. Hard link

```bash
ln $HOME/test/myfile.txt $HOME/hardlink
```
15. Inodes

```bash
ls -i /etc/docker/key.json > $HOME/inodes.txt
```
16. Inodes

```bash
touch myscript.sh mytext && mkdir mydir && chmod 751 myscript.sh && chmod 664 mytext && chmod 700 mydir
```

### Quiz answers

1. 1
2. 3
3. 2
4. 4
5. 3
6. 1
7. 4
8. 4
9. 1
10. 3
11. 3
12. 3
13. 2
14. 3
15. 4
16. 3
17. 2
18. 1
19. 2
20. 2
21. 4
22. 1
23. 4
24. 3
25. 3
26. 3
27. 1
28. 4
29. 2
30. 4
31. 1
32. 2
33. 3
34. 2