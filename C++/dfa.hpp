#include <bits/stdc++.h>

using namespace std;

class State {
public:
  bool is_start;
  bool is_final;
  string name;
  
  State(bool s_start, bool s_final, string s_name);
};

class DFA {
private:
  int num_start_states;
public:
  vector<string> sigma;
  map<string, vector<tuple<string, string, string>>> transitions;
  map<string, State*> states;
  int rejected;

  State* curr_state;
  
  DFA(vector<string> alphabet);
  void add_state(bool is_start, bool is_final, string name);
  void add_transition(string curr_state, string input_symbol, string next_state);
  State* get_start_state();
  vector<string> get_final_states();
  void apply_transition(vector<string> partial_transition);
  void evaluate_string(string str);
};
