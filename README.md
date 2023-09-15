# namemash
Generate a list of possible usernames from a person's first and last name.

# Usage
```
cat <<___EOF___>> names.lst
john doe
___EOF___
./namemash.sh names.lst

echo "John Doe" | ./namemash.sh - | grep -v '[A-Z]' | wc -l
      38
echo "John Doe" | ./namemash.sh - |  wc -l
     114
echo "John Doe Smith" | ./namemash.sh - |  wc -l
     132
```

