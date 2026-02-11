package com.example.demo.riot.schedule;

import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.demo.riot.component.DataInitService;
import com.example.demo.riot.component.RiotData;
import com.example.demo.riot.mapper.ChampionInfoMapper;
import com.example.demo.riot.mapper.ChampionRotationMapper;
import com.example.demo.riot.vo.ChampRotationVO;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class RotationSchedule {

	private static final String ROTATION_URL = "https://kr.api.riotgames.com/lol/platform/v3/champion-rotations";

	@Autowired
	private RiotData riotData;

	@Autowired
	private DataInitService dataInitService;

	@Resource
	private ChampionRotationMapper championRotationMapper;

	@Resource
	private ChampionInfoMapper championInfoMapper;

	/**
	 * Riot API에서 로테이션 데이터를 가져와 DB에 갱신
	 * champion_info가 비어있으면 DataInitService로 동기화
	 */
	public int fetchAndUpdateRotation() {
		try {
			if (championInfoMapper.countChampionInfo() == 0) {
				log.info("champion_info 비어있음 - 초기 데이터 세팅 시작");
				dataInitService.initAllData();
			}

			String response = riotData.getReadData(ROTATION_URL);
			if (response == null) {
				log.error("로테이션 API 응답 없음");
				return -1;
			}

			ObjectMapper om = new ObjectMapper();
			ChampRotationVO rc = om.readValue(response, ChampRotationVO.class);
			List<Integer> rotationList = rc.getFreeChampionIds();
			log.info("로테이션 챔피언 목록: {}", rotationList);

			if (rotationList == null || rotationList.isEmpty()) {
				log.warn("로테이션 챔피언 목록이 비어있음");
				return 0;
			}

			championRotationMapper.deleteChampionRotation();
			int result = 0;
			for (int championInfoKey : rotationList) {
				result += championRotationMapper.insertChampionRotation(championInfoKey);
			}

			log.info("로테이션 갱신 완료: {}개 챔피언", result);
			return result;
		} catch (IOException e) {
			log.error("로테이션 갱신 실패", e);
			return -1;
		}
	}

	@Scheduled(cron = "0 0 0/1 * * 2")
	public void checkRotation() {
		fetchAndUpdateRotation();
	}
}
