package com.example.demo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

import com.example.demo.riot.component.DataInitService;
import com.example.demo.riot.mapper.ChampionInfoMapper;

import lombok.extern.slf4j.Slf4j;

@SpringBootApplication
@EnableScheduling
@Slf4j
public class Ndibsg2Application implements CommandLineRunner {

	private final ChampionInfoMapper championInfoMapper;
	private final DataInitService dataInitService;

	public Ndibsg2Application(ChampionInfoMapper championInfoMapper, DataInitService dataInitService) {
		this.championInfoMapper = championInfoMapper;
		this.dataInitService = dataInitService;
	}

	public static void main(String[] args) {
		SpringApplication.run(Ndibsg2Application.class, args);
	}

	@Override
	public void run(String... args) {
		if (championInfoMapper.countChampionInfo() == 0) {
			log.info("초기 데이터가 비어있음 → 자동 세팅 시작");
			dataInitService.initAllData();
		} else {
			log.info("초기 데이터 존재 → 스킵 (수동: GET /data/init)");
		}
	}
}
