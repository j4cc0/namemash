# namemash

Proof-of-concept code. Inspired by https://gist.github.com/superkojiman/11076951, written in bash (instead of python).

Generate a list of possible usernames from a person's first and last name.

# Usage

```
cat <<___EOF___>> names.lst
john doe
___EOF___
./namemash.sh names.lst

echo "James Tiberius Kirk" | ./namemash.sh -
echo "John Doe" | ./namemash.sh - | grep -v '[A-Z]' | wc -l
echo "John Doe" | ./namemash.sh - |  wc -l
echo "John Doe Smith" | ./namemash.sh - | sed 's/$/@example.com/'
```

