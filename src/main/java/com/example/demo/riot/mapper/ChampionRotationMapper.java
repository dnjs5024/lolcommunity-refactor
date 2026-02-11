package com.example.demo.riot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.riot.vo.ChampionInfoVO;

@Mapper
public interface ChampionRotationMapper {
	int insertChampionRotation(@Param("championInfoKey") int championInfoKey);
	List<ChampionInfoVO> selectChampionRotation();
	int deleteChampionRotation();
}
