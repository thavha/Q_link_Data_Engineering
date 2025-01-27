def string_compare(string1, string2):
    """
    Compares two strings to calculate their similarity percentage based on unique words.

    This function converts both strings to lowercase, splits them into words, 
    and computes their similarity as a percentage based on the intersection 
    and union of the unique words.

    Args:
        string1 (str): The first string to compare.
        string2 (str): The second string to compare.

    Returns:
        str: The similarity percentage as a formatted string, e.g., '75.0%'.
             If the two strings have identical unique words, it returns '100.0% '.
    """
  
   # Convert both strings to lowercase, split them into words, and create sets of unique words
    unique_string1 = set(string1.lower().split())
    unique_string2 = set(string2.lower().split())
   
    
    # Check if the sets of unique words are identical
    if unique_string1 == unique_string2:
        
        return "100.0% "
    else :
        # Calculate the intersection (common words) and union (total unique words) of the two sets
        intersection = unique_string1.intersection(unique_string2)
        total_string = unique_string1.union(unique_string2)
        
        # Calculate the similarity percentage and return it as a formatted string
        return f'{len(intersection)/len(total_string) * 100}%'
    
print(string_compare('the John Smith junior' , 'Smith John senior'))
    
        