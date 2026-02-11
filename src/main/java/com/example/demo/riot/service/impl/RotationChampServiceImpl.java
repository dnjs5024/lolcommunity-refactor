package com.example.demo.riot.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.riot.mapper.ChampionRotationMapper;
import com.example.demo.riot.schedule.RotationSchedule;
import com.example.demo.riot.service.RotationChampService;
import com.example.demo.riot.vo.ChampionInfoVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class RotationChampServiceImpl implements RotationChampService {

	@Resource
	private ChampionRotationMapper championRotationMapper;

	@Autowired
	private RotationSchedule rotationSchedule;

	@Override
	public List<ChampionInfoVO> getRotationChamp() {
		return championRotationMapper.selectChampionRotation();
	}

	@Override
	public int refreshRotation() {
		return rotationSchedule.fetchAndUpdateRotation();
	}
}
