local skill_numtype_to_type = {"attack", "defend", "start"}
skill_id_to_type = map_dict(function(n) return skill_numtype_to_type[n] end,
                   {[1001]=3,[1002]=1,[1003]=1,[1004]=2,[1005]=1,[1006]=2,
                    [1007]=3,[1008]=1,[1009]=2,[1010]=1,[1011]=3,[1012]=2,
                    [1013]=1,[1014]=1,[1015]=3,[1016]=2,[1017]=2,[1018]=2,
                    [1019]=1,[1020]=3,[1021]=1,[1022]=2,[1023]=3,[1024]=3,
                    [1025]=2,[1026]=1,[1027]=3,[1028]=3,[1029]=1,[1030]=2,
                    [1031]=2,[1033]=2,[1034]=3,[1035]=1,[1036]=1,[1037]=2,
                    [1038]=1,[1039]=3,[1040]=2,[1041]=2,[1042]=1,[1043]=2,
                    [1044]=1,[1045]=1,[1046]=2,[1047]=2,[1048]=1,[1049]=1,
                    [1050]=3,[1051]=3,[1052]=3,[1053]=3,[1054]=1,[1057]=2,
                    [1058]=3,[1059]=1,[1060]=1,[1061]=3,[1062]=2,[1063]=3,
                    [1064]=3,[1065]=2,[1066]=3,[1067]=1,[1068]=3,[1069]=2,
                    [1070]=3,[1071]=2,[1072]=1,[1074]=2,[1075]=1,[1077]=1,
                    [1078]=1,[1079]=2,[1080]=1,[1081]=1,[1082]=2,[1083]=1,
                    [1084]=3,[1085]=1,[1086]=1,[1087]=2,[1088]=2,[1089]=1,
                    [1090]=1,[1091]=2,[1092]=2,[1093]=1,[1094]=2,[1095]=3,
                    [1096]=3,[1097]=2,[1098]=1,[1099]=1,[1100]=2,[1101]=1,
                    [1102]=3,[1103]=2,[1104]=1,[1105]=2,[1106]=3,[1107]=2,
                    [1108]=1,[1109]=1,[1110]=3,[1111]=3,[1112]=2,[1113]=1,
                    [1114]=2,[1115]=1,[1116]=3,[1117]=2,[1118]=1,[1119]=2,
                    [1120]=1,[1121]=3,[1122]=2,[1123]=1,[1174]=1,[1218]=1,
                    [1219]=2,[1314]=1,[1315]=1,[1316]=2,})
setmetatable(skill_id_to_type, {__index = function() return "start" end})

local refresh_id = 1076

skill_func = {
-- untested
-- new cook club student, may i see?
[1001] = function(player)
  local target_idx = uniformly(player:field_idxs_with_preds({pred.cook_club,pred.follower}))
  if target_idx then
    local buff = GlobalBuff(player)
    buff.field[player][target_idx] = {atk={"+",1}, sta={"+",1}}
    buff:apply()
  end
end,

-- cook club katie, best taste ever!
[1002] = function(player, my_idx, my_card)
  if my_card.sta > 1 then
    local buff = GlobalBuff(player)
    buff.field[player][my_idx] = {atk={"+",1}, sta={"-"},1}
    buff:apply()
  end
end,

-- cook club sylphie, 25 assistant asmis, crescent elder riesling, best attack
[1003] = function(player, my_idx)
  local buff = GlobalBuff(player)
  buff.field[player][my_idx] = {atk={"+",1}}
  buff:apply()
end,

-- prefect layna, proper behavior
[1004] = function(player, my_idx)
  local buff = GlobalBuff(player)
  buff.field[player][my_idx] = {sta={"+",#player.hand + 1}}
  buff:apply()
end,

-- lib. serie, wrath of the book!
[1005] = function(player, my_idx)
  local libs = #player:hand_idxs_with_preds({pred.lib})
  if libs > 0 then
    local buff = GlobalBuff(player)
    buff.field[player][my_idx] = {atk={"+",libs}}
    buff:apply()
  end
end,

-- lib vernika, sita's friend rosie, 25 agent nine, seeker luthera, lost doll, best defense
[1006] = function(player, my_idx)
  local buff = GlobalBuff(player)
  buff.field[player][my_idx] = {def={"+",2}}
  buff:apply()
end,

-- tested
-- guard maid, maid cross
[1007] = function(player)
  local target_idx = uniformly(player:field_idxs_with_preds({pred.maid,pred.follower}))
  if target_idx then
    local buff = GlobalBuff(player)
    buff.field[player][target_idx] = {atk={"+",1}, sta={"+",1}}
    buff:apply()
  end
end,

-- chief maid, maid wisdom
[1008] = function(player, my_idx)
  local spell_idx = player:hand_idxs_with_preds({pred.spell})[1]
  if spell_idx then
    player:hand_to_grave(spell_idx)
    local buff = GlobalBuff(player)
    buff.field[player][my_idx] = {atk={"+",2}}
    buff:apply()
  end
end,

-- mop maid, mop slash
[1009] = function(player, my_idx)
  local buff = GlobalBuff(player)
  local idxs = player:field_idxs_with_preds({pred.follower})
  for _,idx in ipairs(idxs) do
    if math.abs(my_idx - idx) <= 1 then
      buff.field[player][idx] = {atk={"+",1}}
    end
  end
  buff:apply()
end,

-- aristocrat girl, noblesse
[1010] = function(player, my_idx, my_card, other_idx, other_card)
  if other_card.def >= 2 then
    local buff = GlobalBuff(player)
    buff.field[player.opponent][other_idx] = {sta={"-",3}}
    buff:apply()
  end
end,

--private maid, true caring
[1011] = function(player)
  local target_idx = uniformly(player.opponent:field_idxs_with_preds({pred.follower}))
  if target_idx then
    local buff = GlobalBuff(player)
    buff.field[player.opponent][target_idx] = {atk={"-",1}}
    buff:apply()
  end
end,

--senpai maid, i'll try my best
[1012] = function(player, my_idx)
  local buff = GlobalBuff(player)
  buff.field[player][my_idx] = {atk={"+",1}, sta={"+",2}}
  buff:apply()
end,

--striker, fireball!
[1013] = function(player, my_idx, my_card, other_idx)
  local buff = GlobalBuff(player)
  buff.field[player.opponent][other_idx] = {sta={"-",1}}
  buff:apply()
end,

-- untested
-- flag knight frett, flag return
[1014] = function(player)
  if player.field[3] and player.field[3].type == "follower" then
    local buff = GlobalBuff(player)
    buff.field[player][3] = {atk={"+",1}, sta={"+",1}}
    buff:apply()
  end
end,

-- knight adjt. sarisen, sisters in arms
[1015] = function(player, my_idx)
  local idxs = player:field_idxs_with_preds({pred.knight,pred.follower})
  if #idxs > 1 then
    local buff = OnePlayerBuff(player)
    for _,idx in ipairs(idxs) do
      if idx ~= my_idx then
        buff[idx] = {atk={"+",1}, sta={"+",1}}
      end
    end
    buff:apply()
  end
end,

-- crux knight pintail, contract witch, surprise!
[1016] = function(player, my_idx, my_card, other_idx, other_card)
  if other_card.size < my_card.size then
    local buff = GlobalBuff(player)
    buff.field[player][my_idx] = {atk={"+",1}, sta={"+",1}}
    buff:apply()
  end
end,

-- priestess, healing prayer
[1017] = function(player)
  local buff = OnePlayerBuff(player)
  buff[0] = {life={"+",1}}
  buff:apply()
end,

-- seeker amethystar, holy heal
[1018] = function(player, my_idx)
  if player.game.turn % 2 == 1 then
    OneBuff(player, my_idx, {sta={"+",3}}):apply()
  end
end,

-- seeker lydia, cross
[1019] = function(player, my_idx, my_card, other_idx)
  if #player.field_idxs_with_preds({pred.faction.C}) >= 2 then
    OneBuff(player.opponent, other_idx, {atk={"-",1}, def={"-",2}, sta={"-",1}}):apply()
  end
end,

-- acolyte, holy peace
[1020] = function(player)
  if player.game.turn % 2 == 0 then
    local target_idxs = player:field_idxs_with_preds({pred.faction.C, pred.follower})
    local buff = OnePlayerBuff(player)
    for _,idx in ipairs(target_idxs) do
      buff[idx] = {atk={"+",2}, sta={"+",2}}
    end
    buff:apply()
  end
end,

-- scardel sion flina, sion attack!
[1021] = function(player)
  local target_idxs = player:field_idxs_with_preds({pred.sion_rion, pred.follower})
  local buff = OnePlayerBuff(player)
  for _,idx in ipairs(target_idxs) do
    buff[idx] = {atk={"+",1}}
  end
  buff:apply()
end,

-- scardel rion flina, rion defense!
[1022] = function(player)
  local target_idxs = player:field_idxs_with_preds({pred.sion_rion, pred.follower})
  local buff = OnePlayerBuff(player)
  for _,idx in ipairs(target_idxs) do
    buff[idx] = {sta={"+",1}}
  end
  buff:apply()
end,

-- moondancer kata flina, moonlight dancer!
[1023] = function(player)
  local target_idxs = shuffle(player.opponent:field_idxs_with_preds({pred.follower}))
  if #target_idxs >= 1 then
    local buff = OnePlayerBuff(player.opponent)
    for i=1,min(2,#target_idxs) do
      buff[target_idxs[i]] = {atk={"-",1}, sta={"-",1}}
    end
    buff:apply()
  end
end,

-- scardel shiraz, night's place
[1024] = function(player)
  if #player:field_idxs_with_preds({pred.faction.D,pred.follower}) then
    local target_idx = uniformly(player.opponent:field_idxs_with_preds({pred.follower}))
    OneBuff(player.opponent, target_idx, {sta={"-",2}}):apply()
  end
end,

-- master luna flina, moon guardian
[1025] = function(player, my_idx)
  local new_def = #player:hand_idxs_with_preds({pred.faction.D, pred.follower})
  OneBuff(player, my_idx, {def={"=",new_def}, sta={"+",new_def}}):apply()
end,

-- red moon aka flina, cook club ace, silent maid, seeker director, lantern witch,
-- coin lady, reverse defense
[1026] = function(player, my_idx, my_card, other_idx, other_card)
  local diff = abs(other_card.def)
  OneBuff(player, my_idx, {atk={"+",diff}, def={"=",0}, sta={"+",diff}}):apply()
end,

-- blue moon beecky flina, chilly blood
[1027] = function(player, my_idx)
  local target_idxs = shuffle(player.field_idxs_with_preds({pred.follower}))
  local buff = OnePlayerBuff(player)
  buff[my_idx] = {atk={"+",1}, sta={"+",1}}
  if #target_idxs >= 2 then
    if target_idxs[1] == my_idx then
      buff[target_idxs[2]] = {atk={"+",1}, sta={"+",1}}
    else
      buff[target_idxs[1]] = {atk={"+",1}, sta={"+",1}}
    end
  end
  buff.apply()
end,

}

setmetatable(skill_func, {__index = function() return function() end end})
