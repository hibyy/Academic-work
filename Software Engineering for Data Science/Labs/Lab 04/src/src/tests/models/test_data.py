import csv
import pytest
import sys
import os

# Update the path to include the directory for the row_to_list function
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../..")))
from src.models.row_2_list import row_to_list  # Import the function to be tested

# Load your dataset from the CSV file
dataset = []
with open('src/tests/data/house_price.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=';')  # Use ';' as delimiter
    for row in csvreader:
        dataset.append(row)

# Test if the function correctly handles rows with missing values
@pytest.mark.parametrize("input_row", dataset)
def test_row_to_list_with_missing_values(input_row):
    # Check for any missing values (empty strings) in the row
    has_missing_values = any(value == '' for value in input_row)
    
    # Assert that the row does not contain any missing values
    assert not has_missing_values, f"Missing value found in row: {input_row}"
