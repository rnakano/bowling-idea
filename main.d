import std.conv, std.ascii;

immutable char STRIKE_MARK = 'X';
immutable char SPEAR_MARK = '/';
immutable char GUTTER_MARK = '-';

int calculate_score(string score_string)
{
  auto down_pins = knock_down_pins(score_string);
  assert(down_pins.length == score_string.length);

  auto tail_frame_score_string = cut_tail_frame(score_string);
  auto head_frame_score_string =
    score_string[0..($-tail_frame_score_string.length)];

  int score = 0;

  // head (#1 to #9) frames
  for(int i = 0; i < head_frame_score_string.length; i++)
  {
    immutable char score_char = head_frame_score_string[i];

    // add normal score
    score += down_pins[i];
    
    // add special score
    if(score_char == STRIKE_MARK) {
      score += down_pins[i+1] + down_pins[i+2];
    } else if(score_char == SPEAR_MARK) {
      score += down_pins[i+1];
    }
  }

  // tail (#10 frame) frame
  // in #10 frame, get no special score
  auto tail_frame_down_pins = knock_down_pins(tail_frame_score_string);
  for(int i = 0; i < tail_frame_score_string.length; i++)
  {
    score += tail_frame_down_pins[i];
  }
  
  return score;
}

unittest {
  assert(calculate_score("--X-") == 10);
  assert(calculate_score("--32X") == 3+2+10);
  assert(calculate_score("---") == 0);
  assert(calculate_score("--X3/") == 10+3+7);
  assert(calculate_score("--XXX") == 10+10+10);

  // perfect game score
  assert(calculate_score("XXXXXXXXXXXX") == 300);
  // datch man score
  assert(calculate_score("X1/X1/X1/X1/X1/X") == 200);
}

string cut_tail_frame(string score_string)
{
  assert(score_string.length >= 2);
  if(score_string[$-2] == STRIKE_MARK || score_string[$-2] == SPEAR_MARK
     || score_string[$-3] == STRIKE_MARK) {
    return score_string[($-3)..$];
  } else {
    return score_string[($-2)..$];
  }
}

unittest {
  assert(cut_tail_frame("--XXX") == "XXX");
  assert(cut_tail_frame("--32") == "32");
  assert(cut_tail_frame("246/5") == "6/5");
}

int[] knock_down_pins(string score_string)
{
  int prev_pins = 0;
  int[] down_pins;
  
  foreach(immutable char score_char; score_string)
  {
    int pins;
    if(score_char == STRIKE_MARK) {
      pins = 10;
    } else if(score_char == GUTTER_MARK) {
      pins = 0;
    } else if(score_char == SPEAR_MARK) {
      pins = 10 - prev_pins;
    } else {
      assert(isDigit(score_char));
      pins = score_char - '0';
    }
    down_pins ~= pins;
    prev_pins = pins;
  }
  
  return down_pins;
}

unittest {
  assert(knock_down_pins("3") == [3]);
  assert(knock_down_pins("32") == [3, 2]);
  assert(knock_down_pins("X") == [10]);
  assert(knock_down_pins("4/") == [4, 6]);
  assert(knock_down_pins("-") == [0]);
  assert(knock_down_pins("X2/") == [10, 2, 8]);
}

void main(string[] args)
{
  
}
