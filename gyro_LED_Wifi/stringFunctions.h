//additional functions to parse incoming xml files from laptop
#ifndef STRINGFUNCTIONS_H
#define STRINGFUNCTIONS_H

// Function to clear a string

void clearStr(char* str) {
  int len = strlen(str);
  for (int c = 0; c < len; c++) {
    str[c] = 0;
  }
}

//Function to add a char to a string and check its length

void addChar(char ch, char* str) {
  char *tagMsg  = "<TRUNCATED_TAG>";
  char *dataMsg = "-TRUNCATED_DATA-";

  // Check the max size of the string to make sure it doesn't grow too
  // big.  If string is beyond MAX_STRING_LEN assume it is unimportant
  // and replace it with a warning message.
  if (strlen(str) > MAX_STRING_LEN - 2) {
    if (tagFlag) {
      clearStr(tagStr);
      strcpy(tagStr, tagMsg);
    }
    if (dataFlag) {
      clearStr(dataStr);
      strcpy(dataStr, dataMsg);
    }

    // Clear the temp buffer and flags to stop current processing
    clearStr(tmpStr);
    tagFlag = false;
    dataFlag = false;

  } else {
    // Add char to string
    str[strlen(str)] = ch;
  }
}

// Function to check the current tag for a specific string
boolean matchTag (char* searchTag) {
  if (strcmp(tagStr, searchTag) == 0 ) {
    return true;
  } else {
    return false;
  }
}

#endif
