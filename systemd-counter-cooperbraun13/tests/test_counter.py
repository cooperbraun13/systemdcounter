import datetime
from bin.counter import format_output_line

def test_format_output_line():
    name = "Cooper"
    counter = 5
    test_time = "2025-02-15 12:00:00"
    expected_line = f"Cooper: {test_time} #5"
    assert format_output_line(name, counter, test_time) == expected_line



