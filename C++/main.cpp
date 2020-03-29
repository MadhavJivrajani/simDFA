#include <bits/stdc++.h>
#include "dfa.hpp"

using namespace std;

int main() {
  vector<string> alphabet = {"a", "b"};
  DFA dfa(alphabet);

  dfa.add_state(true, true, "q0");
  dfa.add_state(false, true, "q1");
  dfa.add_state(false, true, "q2");
  dfa.add_state(false, true, "q3");
  dfa.add_state(false, false, "q4");

  dfa.add_transition("q0", "a", "q1");
  dfa.add_transition("q0", "b", "q0");
  dfa.add_transition("q1", "a", "q2");
  dfa.add_transition("q1", "b", "q1");
  dfa.add_transition("q2", "a", "q3");
  dfa.add_transition("q2", "b", "q2");
  dfa.add_transition("q3", "a", "q4");
  dfa.add_transition("q3", "b", "q3");
  dfa.add_transition("q4", "a", "q4");
  dfa.add_transition("q4", "b", "q4");

  dfa.evaluate_string("aaab");  //Accepted!
  dfa.evaluate_string("aaaab"); //Rejected
  dfa.evaluate_string("");	//Accepted!
  dfa.evaluate_string("bbbb");  //Accepted!
}
