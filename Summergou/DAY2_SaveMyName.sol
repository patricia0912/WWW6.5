function saveAndRetrieve(string memory myname, string memory mybio, string memory myage) public returns (string memory, string memory, string memory) {
    name = myname;
    bio = mybio;
    age = myage;
    return (name, bio, age);
}


