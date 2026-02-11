package com.example.demo.riot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.riot.vo.ChampionInfoVO;
import com.example.demo.riot.vo.ChampionSpellVO;

@Mapper
public interface ChampionSpellMapper {
	int insertChampionSpell (ChampionSpellVO spell);
	List<ChampionSpellVO> selectChampionSpellList (ChampionInfoVO champ);
	int deleteChampionSpellByKey(int championInfoKey);
	int deleteAllChampionSpell();
}
