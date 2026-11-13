178,0
S,Settings,Current global settings,0,0,0,0,0,0,0,457,-38,-38,-38,-38,-38
S,Settings,"Convert S=[[""key"",""value""],...] to a setting array",1,0,1,82,1,82,0,298,1,0,0,0,0,0,0,0,82,,457,-38,-38,-38,-38,-38
S,SetSettings,Set all global settings (overwrite),0,1,0,0,1,0,0,0,0,457,,-38,-38,-38,-38,-38,-38
S,SetSettings,"Set all global settings (overwrite), S=[[""key"",""value""],...]",1,0,1,82,1,82,0,298,1,0,0,1,0,0,0,0,82,,-38,-38,-38,-38,-38,-38
S,AddSettings,Add settings N to S,0,2,0,0,1,0,0,0,0,457,,1,1,457,,-38,-38,-38,-38,-38,-38
S,AddSettings,"Add N=[[""key"",""value""],...] to settings S",1,1,1,82,1,82,0,298,2,0,0,1,0,0,0,0,82,,1,1,457,,-38,-38,-38,-38,-38,-38
S,AddSettings,Add to global settings,0,1,0,0,1,0,0,0,0,457,,-38,-38,-38,-38,-38,-38
S,AddSettings,"Add to global settings, N=[[""key"",""value""],...]",1,0,1,82,1,82,0,298,1,0,0,1,0,0,0,0,82,,-38,-38,-38,-38,-38,-38
S,GetSetting,"Get a setting from a setting array S, raise error if not found",0,2,0,0,0,0,0,0,0,298,,0,0,457,,-1,-38,-38,-38,-38,-38
S,GetSetting,"Get a global setting, raise error if not found",0,1,0,0,0,0,0,0,0,298,,-1,-38,-38,-38,-38,-38
S,GetSettingZ,"Get an integer setting from a setting array S, raise error if not found",0,2,0,0,0,0,0,0,0,298,,0,0,457,,148,-38,-38,-38,-38,-38
S,GetSettingZ,"Get a global integer setting, raise error if not found",0,1,0,0,0,0,0,0,0,298,,148,-38,-38,-38,-38,-38
S,GetSettingBool,"Get a boolean setting from a setting array S, raise error if not found",0,2,0,0,0,0,0,0,0,298,,0,0,457,,36,-38,-38,-38,-38,-38
S,GetSettingBool,"Get a global boolean setting, raise error if not found",0,1,0,0,0,0,0,0,0,298,,36,-38,-38,-38,-38,-38
S,HaveSetting,"Check if S has a setting key, return true, S[key] if yes",0,2,0,0,0,0,0,0,0,298,,0,0,457,,36,-1,-38,-38,-38,-38
S,HaveSetting,"Check if there is a global setting key, return true, Settings()[key] if yes",0,1,0,0,0,0,0,0,0,298,,36,-1,-38,-38,-38,-38
S,SetSetting,"Set a setting S[key]:=v; if new=true, only set if not set yet",0,3,0,0,1,0,0,0,0,-1,,0,0,298,,1,1,457,,-38,-38,-38,-38,-38,-38
S,SetSetting,"Set a global setting; if new=true, only set if not set yet",0,2,0,0,1,0,0,0,0,-1,,0,0,298,,-38,-38,-38,-38,-38,-38
S,DefaultModelSettings,Default TeX settings for regular models,0,0,0,0,0,0,0,457,-38,-38,-38,-38,-38
