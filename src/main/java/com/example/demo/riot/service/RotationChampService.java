package com.example.demo.riot.service;

import java.util.List;

import com.example.demo.riot.vo.ChampionInfoVO;

public interface RotationChampService {
	List<ChampionInfoVO> getRotationChamp();
	int refreshRotation();
}
