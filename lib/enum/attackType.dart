enum AttackType { Melee, Ranged }
String attackTpyeStr(AttackType type) {
  if (type == AttackType.Melee) {
    return "Melee";
  }
  return "Ranged";
}
