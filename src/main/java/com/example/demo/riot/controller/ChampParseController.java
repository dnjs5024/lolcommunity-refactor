package com.example.demo.riot.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.riot.component.DataInitService;
import com.example.demo.riot.service.ChampInfoService;
import com.example.demo.riot.service.ChampSpellService;
import com.example.demo.riot.service.RankChampService;
import com.example.demo.riot.service.RotationChampService;
import com.example.demo.riot.vo.ChampionInfoVO;
import com.example.demo.riot.vo.ChampionSpellVO;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
public class ChampParseController {

	@Autowired
	private ChampSpellService cs;
	@Autowired
	private ChampInfoService ci;
	@Autowired
	private RankChampService rcs;
	@Autowired
	private RotationChampService rotationChampService;
	@Autowired
	private DataInitService dataInitService;

	@GetMapping("/champList")
	public List<ChampionInfoVO> doChampionList(String search) {
		log.info("{}",search);
		return ci.selectChampionInfoList(null, search);
	}
	@GetMapping("/champ/position")
	public List<ChampionInfoVO> doPositionList(String position) {
		return ci.selectChampionInfoPosition(position);
	}

	@PostMapping("/spell")
	public List<ChampionSpellVO> doChampionSpells(ChampionInfoVO civ) {
		log.info("{}",civ);
		List<ChampionSpellVO>cs1 = cs.champSpells(civ);
		log.info("{}",cs1);
		return cs.champSpells(civ);
	}

	/**
	 * 로테이션 챔피언 수동 갱신
	 * GET /champ/rotation/refresh
	 */
	@GetMapping("/champ/rotation/refresh")
	public Map<String, Object> doRefreshRotation() {
		int result = rotationChampService.refreshRotation();
		Map<String, Object> response = new HashMap<>();
		if (result > 0) {
			response.put("success", true);
			response.put("count", result);
			response.put("message", "로테이션 갱신 완료");
		} else {
			response.put("success", false);
			response.put("message", "로테이션 갱신 실패 - API 키를 확인하세요");
		}
		return response;
	}

	/**
	 * 로테이션 챔피언 목록 조회
	 * GET /champ/rotation
	 */
	@GetMapping("/champ/rotation")
	public List<ChampionInfoVO> doRotationList() {
		return rotationChampService.getRotationChamp();
	}

	/**
	 * DDragon 전체 초기 데이터 세팅
	 * GET /data/init
	 * champion_info, champion_spell, summoner_spell, rune_info 한번에 동기화
	 */
	@GetMapping("/data/init")
	public Map<String, Object> doInitData() {
		return dataInitService.initAllData();
	}
}
