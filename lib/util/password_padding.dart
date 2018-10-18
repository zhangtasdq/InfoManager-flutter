const PADDING_CHARS = ['`', '~', '(', ')', ':', '"', ',', '!', '@', '+', 'a', 'c',
                      'd', '.', '\\', 'w', 'r', 'p', 'l', 'e', '=', '&', '^', '\$',
                      '#', '?', '>', '<', ';', '{', 'y', 'v', 'm', 'i', 'g', 'h',
                      'H', 'P', 'S', 'Q', '}', '|', '[', ']', '*', '%', 'X', 'Z',
                      'S', 'J'];

String passwordPadding(String password, int minLength) {
    if (password.length >= minLength) {
        return password;
    }


    int paddingCount = minLength - password.length,
        leftCount = paddingCount ~/ 2,
        rightCount = minLength - password.length - leftCount;

    for(int i = 0; i < leftCount; ++i) {
        password = PADDING_CHARS[i % PADDING_CHARS.length] + password;
    }

    for(int i = 0; i < rightCount; ++i) {
        password = password + PADDING_CHARS[i % PADDING_CHARS.length];
    }

    return password;
}