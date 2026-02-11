package com.example.demo.riot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.riot.vo.ChampionInfoVO;

@Mapper
public interface ChampionInfoMapper {
	int insertChampionInfo (ChampionInfoVO champion);
	int upsertChampionInfo (ChampionInfoVO champion);
	int countChampionInfo();
	List<ChampionInfoVO> selectChampionInfoList (ChampionInfoVO champion);
	List<ChampionInfoVO> selectChampionInfoPosition (String position);
	List<ChampionInfoVO> searchChampionInfoList (String search);
	ChampionInfoVO selectChampionInfo (ChampionInfoVO champion);
}
